# filebeat_legacy::service
#
# Manage the filebeat service
#
# @summary Manage the filebeat service
class filebeat_legacy::service {
  service { 'filebeat':
    ensure   => $filebeat_legacy::real_service_ensure,
    enable   => $filebeat_legacy::service_enable,
    provider => $filebeat_legacy::service_provider,
  }
}
