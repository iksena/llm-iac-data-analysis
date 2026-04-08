resource "aws_connect_user" "this" {
  instance_id          = var.instance_id
  name                 = var.name
  directory_user_id    = var.directory_user_id
  hierarchy_group_id   = var.hierarchy_group_id
  password             = var.password
  routing_profile_id   = var.routing_profile_id
  security_profile_ids = var.security_profile_ids
  tags                 = var.tags

  dynamic "identity_info" {
    for_each = var.identity_info != null ? [var.identity_info] : []
    content {
      email           = identity_info.value.email
      first_name      = identity_info.value.first_name
      last_name       = identity_info.value.last_name
      secondary_email = identity_info.value.secondary_email
    }
  }

  phone_config {
    after_contact_work_time_limit = var.phone_config.after_contact_work_time_limit
    auto_accept                   = var.phone_config.auto_accept
    desk_phone_number             = var.phone_config.desk_phone_number
    phone_type                    = var.phone_config.phone_type
  }
}