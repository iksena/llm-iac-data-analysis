resource "aws_memorydb_parameter_group" "this" {
  family      = var.family
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
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