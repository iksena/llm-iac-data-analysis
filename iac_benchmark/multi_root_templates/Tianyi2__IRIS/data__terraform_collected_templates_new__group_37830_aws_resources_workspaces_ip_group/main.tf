resource "aws_workspaces_ip_group" "this" {
  name        = var.name
  description = var.description
  region      = var.region
  tags        = var.tags

  dynamic "rules" {
    for_each = var.rules
    content {
      source      = rules.value.source
      description = rules.value.description
    }
  }
}