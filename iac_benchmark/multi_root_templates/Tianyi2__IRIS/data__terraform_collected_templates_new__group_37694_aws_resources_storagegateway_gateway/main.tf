resource "aws_storagegateway_gateway" "this" {
  gateway_name     = var.gateway_name
  gateway_timezone = var.gateway_timezone

  activation_key                              = var.activation_key
  average_download_rate_limit_in_bits_per_sec = var.average_download_rate_limit_in_bits_per_sec
  average_upload_rate_limit_in_bits_per_sec   = var.average_upload_rate_limit_in_bits_per_sec
  gateway_ip_address                          = var.gateway_ip_address
  gateway_type                                = var.gateway_type
  gateway_vpc_endpoint                        = var.gateway_vpc_endpoint
  cloudwatch_log_group_arn                    = var.cloudwatch_log_group_arn
  medium_changer_type                         = var.medium_changer_type
  smb_guest_password                          = var.smb_guest_password
  smb_security_strategy                       = var.smb_security_strategy
  smb_file_share_visibility                   = var.smb_file_share_visibility
  tape_drive_type                             = var.tape_drive_type
  tags                                        = var.tags

  dynamic "maintenance_start_time" {
    for_each = var.maintenance_start_time != null ? [var.maintenance_start_time] : []
    content {
      day_of_month   = maintenance_start_time.value.day_of_month
      day_of_week    = maintenance_start_time.value.day_of_week
      hour_of_day    = maintenance_start_time.value.hour_of_day
      minute_of_hour = maintenance_start_time.value.minute_of_hour
    }
  }

  dynamic "smb_active_directory_settings" {
    for_each = var.smb_active_directory_settings != null ? [var.smb_active_directory_settings] : []
    content {
      domain_name         = smb_active_directory_settings.value.domain_name
      password            = smb_active_directory_settings.value.password
      username            = smb_active_directory_settings.value.username
      timeout_in_seconds  = smb_active_directory_settings.value.timeout_in_seconds
      organizational_unit = smb_active_directory_settings.value.organizational_unit
      domain_controllers  = smb_active_directory_settings.value.domain_controllers
    }
  }
}