data "aws_imagebuilder_infrastructure_configurations" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}