locals {
  name_conflict_check = var.name != null && var.name_prefix != null ? tobool("resource_aws_db_parameter_group, name conflicts with name_prefix. Only one can be specified.") : true
}

resource "aws_db_parameter_group" "this" {
  region       = var.region
  name         = var.name
  name_prefix  = var.name_prefix
  family       = var.family
  description  = var.description
  skip_destroy = var.skip_destroy
  tags         = var.tags

  dynamic "parameter" {
    for_each = var.parameter
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}