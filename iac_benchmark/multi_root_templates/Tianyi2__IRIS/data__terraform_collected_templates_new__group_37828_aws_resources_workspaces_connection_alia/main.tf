resource "aws_workspaces_connection_alias" "this" {
  region            = var.region
  connection_string = var.connection_string
  tags              = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}