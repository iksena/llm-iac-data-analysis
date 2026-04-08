data "aws_secretsmanager_secrets" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}