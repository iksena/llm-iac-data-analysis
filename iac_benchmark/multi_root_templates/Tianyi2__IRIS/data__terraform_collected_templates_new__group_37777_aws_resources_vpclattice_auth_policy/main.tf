resource "aws_vpclattice_auth_policy" "this" {
  region              = var.region
  resource_identifier = var.resource_identifier
  policy              = var.policy

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}