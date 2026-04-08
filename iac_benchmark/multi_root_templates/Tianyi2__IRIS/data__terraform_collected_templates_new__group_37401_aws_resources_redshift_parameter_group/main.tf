resource "aws_redshift_parameter_group" "this" {
  name        = var.name
  family      = var.family
  description = var.description
  region      = var.region
  tags        = var.tags

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}