data "aws_imagebuilder_image_recipes" "this" {
  region = var.region
  owner  = var.owner

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}