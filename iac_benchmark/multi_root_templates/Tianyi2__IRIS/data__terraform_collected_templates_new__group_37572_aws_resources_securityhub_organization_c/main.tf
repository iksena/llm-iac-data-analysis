resource "aws_securityhub_organization_configuration" "this" {
  region                = var.region
  auto_enable           = var.auto_enable
  auto_enable_standards = var.auto_enable_standards

  dynamic "organization_configuration" {
    for_each = var.organization_configuration != null ? [var.organization_configuration] : []
    content {
      configuration_type = organization_configuration.value.configuration_type
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}