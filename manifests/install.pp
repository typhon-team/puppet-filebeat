# filebeat_legacy::install
#
# A private class to manage the installation of Filebeat
#
# @summary A private class that manages the install of Filebeat
class filebeat_legacy::install {
  anchor { 'filebeat_legacy::install::begin': }

  case $::kernel {
    'Linux':   {
      class{ '::filebeat_legacy::install::linux':
        notify => Class['filebeat_legacy::service'],
      }
      Anchor['filebeat_legacy::install::begin'] -> Class['filebeat_legacy::install::linux'] -> Anchor['filebeat_legacy::install::end']
      if $::filebeat_legacy::manage_repo {
        class { '::filebeat_legacy::repo': }
        Class['filebeat_legacy::repo'] -> Class['filebeat_legacy::install::linux']
      }
    }
    'Windows': {
      class{'::filebeat_legacy::install::windows':
        notify => Class['filebeat_legacy::service'],
      }
      Anchor['filebeat_legacy::install::begin'] -> Class['filebeat_legacy::install::windows'] -> Anchor['filebeat_legacy::install::end']
    }
    default:   {
      fail($filebeat_legacy::kernel_fail_message)
    }
  }

  anchor { 'filebeat_legacy::install::end': }

}
