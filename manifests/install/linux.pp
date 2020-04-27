# filebeat_legacy::install::linux
#
# Install the linux filebeat package
#
# @summary A simple class to install the filebeat package
#
class filebeat_legacy::install::linux {
  package {'filebeat':
    ensure => $filebeat_legacy::package_ensure,
  }
}
