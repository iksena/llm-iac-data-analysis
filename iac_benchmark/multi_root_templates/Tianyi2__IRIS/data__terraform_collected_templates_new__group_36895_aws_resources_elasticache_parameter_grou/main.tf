resource "aws_elasticache_parameter_group" "this" {
  region      = var.region
  name        = var.name
  family      = var.family
  description = var.description
  tags        = var.tags

  dynamic "parameter" {
    for_each = var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}