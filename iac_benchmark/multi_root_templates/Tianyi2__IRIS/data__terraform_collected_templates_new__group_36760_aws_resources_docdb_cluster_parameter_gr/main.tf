resource "aws_docdb_cluster_parameter_group" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  family      = var.family
  description = var.description
  tags        = var.tags

  dynamic "parameter" {
    for_each = var.parameter
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}