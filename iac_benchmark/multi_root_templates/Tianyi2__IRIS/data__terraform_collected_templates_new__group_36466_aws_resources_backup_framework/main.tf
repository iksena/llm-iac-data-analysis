resource "aws_backup_framework" "this" {
  name        = var.name
  description = var.description
  region      = var.region
  tags        = var.tags

  dynamic "control" {
    for_each = var.control
    content {
      name = control.value.name

      dynamic "input_parameter" {
        for_each = control.value.input_parameter != null ? control.value.input_parameter : []
        content {
          name  = input_parameter.value.name
          value = input_parameter.value.value
        }
      }

      dynamic "scope" {
        for_each = control.value.scope != null ? [control.value.scope] : []
        content {
          compliance_resource_ids   = scope.value.compliance_resource_ids
          compliance_resource_types = scope.value.compliance_resource_types
          tags                      = scope.value.tags
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}