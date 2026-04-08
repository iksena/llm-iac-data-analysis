resource "aws_guardduty_organization_configuration_feature" "this" {
  region      = var.region
  auto_enable = var.auto_enable
  detector_id = var.detector_id
  name        = var.name

  dynamic "additional_configuration" {
    for_each = var.additional_configuration
    content {
      auto_enable = additional_configuration.value.auto_enable
      name        = additional_configuration.value.name
    }
  }
}