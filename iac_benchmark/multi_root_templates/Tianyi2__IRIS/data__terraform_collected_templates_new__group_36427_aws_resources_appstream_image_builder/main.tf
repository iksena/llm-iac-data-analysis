resource "aws_appstream_image_builder" "this" {
  instance_type                  = var.instance_type
  name                           = var.name
  region                         = var.region
  appstream_agent_version        = var.appstream_agent_version
  description                    = var.description
  display_name                   = var.display_name
  enable_default_internet_access = var.enable_default_internet_access
  iam_role_arn                   = var.iam_role_arn
  image_arn                      = var.image_arn
  image_name                     = var.image_name
  tags                           = var.tags

  dynamic "access_endpoint" {
    for_each = var.access_endpoint
    content {
      endpoint_type = access_endpoint.value.endpoint_type
      vpce_id       = access_endpoint.value.vpce_id
    }
  }

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
}