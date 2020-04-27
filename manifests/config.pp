# filebeat_legacy::config
#
# Manage the configuration files for filebeat
#
# @summary A private class to manage the filebeat config file
class filebeat_legacy::config {
  $major_version = $filebeat_legacy::major_version

  if versioncmp($major_version, '6') >= 0 {
    $filebeat_config = delete_undef_values({
      'shutdown_timeout'  => $filebeat_legacy::shutdown_timeout,
      'name'              => $filebeat_legacy::beat_name,
      'tags'              => $filebeat_legacy::tags,
      'max_procs'         => $filebeat_legacy::max_procs,
      'fields'            => $filebeat_legacy::fields,
      'fields_under_root' => $filebeat_legacy::fields_under_root,
      'filebeat'          => {
        'registry_file'    => $filebeat_legacy::registry_file,
        'config_dir'       => $filebeat_legacy::config_dir,
        'shutdown_timeout' => $filebeat_legacy::shutdown_timeout,
      },
      'output'            => $filebeat_legacy::outputs,
      'shipper'           => $filebeat_legacy::shipper,
      'logging'           => $filebeat_legacy::logging,
      'runoptions'        => $filebeat_legacy::run_options,
      'processors'        => $filebeat_legacy::processors,
    })
  } else {
    $filebeat_config = delete_undef_values({
      'shutdown_timeout'  => $filebeat_legacy::shutdown_timeout,
      'name'              => $filebeat_legacy::beat_name,
      'tags'              => $filebeat_legacy::tags,
      'queue_size'        => $filebeat_legacy::queue_size,
      'max_procs'         => $filebeat_legacy::max_procs,
      'fields'            => $filebeat_legacy::fields,
      'fields_under_root' => $filebeat_legacy::fields_under_root,
      'filebeat'          => {
        'spool_size'       => $filebeat_legacy::spool_size,
        'idle_timeout'     => $filebeat_legacy::idle_timeout,
        'registry_file'    => $filebeat_legacy::registry_file,
        'publish_async'    => $filebeat_legacy::publish_async,
        'config_dir'       => $filebeat_legacy::config_dir,
        'shutdown_timeout' => $filebeat_legacy::shutdown_timeout,
      },
      'output'            => $filebeat_legacy::outputs,
      'shipper'           => $filebeat_legacy::shipper,
      'logging'           => $filebeat_legacy::logging,
      'runoptions'        => $filebeat_legacy::run_options,
      'processors'        => $filebeat_legacy::processors,
    })
  }

  Filebeat_legacy::Prospector <| |> -> File['filebeat.yml']

  case $::kernel {
    'Linux'   : {
      $validate_cmd = $filebeat_legacy::disable_config_test ? {
        true    => undef,
        default => $major_version ? {
          '5'     => '/usr/share/filebeat/bin/filebeat -N -configtest -c %',
          default => '/usr/share/filebeat/bin/filebeat -c % test config',
        },
      }

      file {'filebeat.yml':
        ensure       => $filebeat_legacy::file_ensure,
        path         => $filebeat_legacy::config_file,
        content      => template($filebeat_legacy::conf_template),
        owner        => $filebeat_legacy::config_file_owner,
        group        => $filebeat_legacy::config_file_group,
        mode         => $filebeat_legacy::config_file_mode,
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat-config-dir'],
      }

      file {'filebeat-config-dir':
        ensure  => $filebeat_legacy::directory_ensure,
        path    => $filebeat_legacy::config_dir,
        owner   => $filebeat_legacy::config_dir_owner,
        group   => $filebeat_legacy::config_dir_group,
        mode    => $filebeat_legacy::config_dir_mode,
        recurse => $filebeat_legacy::purge_conf_dir,
        purge   => $filebeat_legacy::purge_conf_dir,
        force   => true,
      }
    } # end Linux

    'Windows' : {
      $cmd_install_dir = regsubst($filebeat_legacy::install_dir, '/', '\\', 'G')
      $filebeat_path = join([$cmd_install_dir, 'Filebeat', 'filebeat.exe'], '\\')

      $validate_cmd = $filebeat_legacy::disable_config_test ? {
        true    => undef,
        default => "\"${filebeat_path}\" -N -configtest -c \"%\"",
      }

      file {'filebeat.yml':
        ensure       => $filebeat_legacy::file_ensure,
        path         => $filebeat_legacy::config_file,
        content      => template($filebeat_legacy::conf_template),
        validate_cmd => $validate_cmd,
        notify       => Service['filebeat'],
        require      => File['filebeat-config-dir'],
      }

      file {'filebeat-config-dir':
        ensure  => $filebeat_legacy::directory_ensure,
        path    => $filebeat_legacy::config_dir,
        recurse => $filebeat_legacy::purge_conf_dir,
        purge   => $filebeat_legacy::purge_conf_dir,
        force   => true,
      }
    } # end Windows

    default : {
      fail($filebeat_legacy::kernel_fail_message)
    }
  }
}
