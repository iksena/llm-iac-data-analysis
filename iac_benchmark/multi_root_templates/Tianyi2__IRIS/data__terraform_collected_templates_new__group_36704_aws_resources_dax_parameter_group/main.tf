resource "aws_dax_parameter_group" "this" {
  region      = var.region
  name        = var.name
  description = var.description

  dynamic "parameters" {
    for_each = var.parameters
    content {
      name  = parameters.value.name
      value = parameters.value.value
    }
  }
}