data "aws_imagebuilder_components" "this" {
  region = var.region
  owner  = var.owner

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}