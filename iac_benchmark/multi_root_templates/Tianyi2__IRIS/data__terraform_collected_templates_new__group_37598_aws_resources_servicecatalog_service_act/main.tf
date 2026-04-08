resource "aws_servicecatalog_service_action" "this" {
  name            = var.name
  description     = var.description
  accept_language = var.accept_language
  region          = var.region

  definition {
    name        = var.definition_name
    version     = var.definition_version
    type        = var.definition_type
    assume_role = var.definition_assume_role
    parameters  = var.definition_parameters
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = lookup(timeouts.value, "create", null)
      read   = lookup(timeouts.value, "read", null)
      update = lookup(timeouts.value, "update", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }
}