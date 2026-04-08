resource "aws_devicefarm_device_pool" "this" {
  region      = var.region
  name        = var.name
  project_arn = var.project_arn
  description = var.description
  max_devices = var.max_devices
  tags        = var.tags

  dynamic "rule" {
    for_each = var.rule
    content {
      attribute = rule.value.attribute
      operator  = rule.value.operator
      value     = rule.value.value
    }
  }
}