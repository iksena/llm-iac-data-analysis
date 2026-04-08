resource "aws_auditmanager_framework" "this" {
  name            = var.name
  compliance_type = var.compliance_type
  description     = var.description
  region          = var.region
  tags            = var.tags

  dynamic "control_sets" {
    for_each = var.control_sets
    content {
      name = control_sets.value.name

      dynamic "controls" {
        for_each = control_sets.value.controls
        content {
          id = controls.value.id
        }
      }
    }
  }
}