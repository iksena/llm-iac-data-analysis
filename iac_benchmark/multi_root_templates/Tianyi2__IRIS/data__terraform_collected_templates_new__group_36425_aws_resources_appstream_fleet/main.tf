resource "aws_appstream_fleet" "this" {
  name          = var.name
  instance_type = var.instance_type

  compute_capacity {
    desired_instances = var.compute_capacity.desired_instances
    desired_sessions  = var.compute_capacity.desired_sessions
  }

  region                             = var.region
  description                        = var.description
  disconnect_timeout_in_seconds      = var.disconnect_timeout_in_seconds
  display_name                       = var.display_name
  enable_default_internet_access     = var.enable_default_internet_access
  fleet_type                         = var.fleet_type
  iam_role_arn                       = var.iam_role_arn
  idle_disconnect_timeout_in_seconds = var.idle_disconnect_timeout_in_seconds
  image_name                         = var.image_name
  image_arn                          = var.image_arn
  stream_view                        = var.stream_view
  max_sessions_per_instance          = var.max_sessions_per_instance
  max_user_duration_in_seconds       = var.max_user_duration_in_seconds

  dynamic "domain_join_info" {
    for_each = var.domain_join_info != null ? [var.domain_join_info] : []
    content {
      directory_name                         = domain_join_info.value.directory_name
      organizational_unit_distinguished_name = domain_join_info.value.organizational_unit_distinguished_name
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  tags = var.tags
}