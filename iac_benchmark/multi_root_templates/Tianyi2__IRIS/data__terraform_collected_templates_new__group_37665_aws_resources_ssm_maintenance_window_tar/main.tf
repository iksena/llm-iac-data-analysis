resource "aws_ssm_maintenance_window_target" "this" {
  region            = var.region
  window_id         = var.window_id
  name              = var.name
  description       = var.description
  resource_type     = var.resource_type
  owner_information = var.owner_information

  dynamic "targets" {
    for_each = var.targets
    content {
      key    = targets.value.key
      values = targets.value.values
    }
  }
}