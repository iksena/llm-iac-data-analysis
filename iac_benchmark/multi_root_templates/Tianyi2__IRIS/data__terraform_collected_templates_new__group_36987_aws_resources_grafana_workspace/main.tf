resource "aws_grafana_workspace" "this" {
  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = var.permission_type

  region                    = var.region
  configuration             = var.configuration
  data_sources              = var.data_sources
  description               = var.description
  grafana_version           = var.grafana_version
  name                      = var.name
  notification_destinations = var.notification_destinations
  organization_role_name    = var.organization_role_name
  organizational_units      = var.organizational_units
  role_arn                  = var.role_arn
  stack_set_name            = var.stack_set_name
  tags                      = var.tags

  dynamic "network_access_control" {
    for_each = var.network_access_control != null ? [var.network_access_control] : []
    content {
      prefix_list_ids = network_access_control.value.prefix_list_ids
      vpce_ids        = network_access_control.value.vpce_ids
    }
  }

  dynamic "vpc_configuration" {
    for_each = var.vpc_configuration != null ? [var.vpc_configuration] : []
    content {
      security_group_ids = vpc_configuration.value.security_group_ids
      subnet_ids         = vpc_configuration.value.subnet_ids
    }
  }
}