data "aws_imagebuilder_image_pipelines" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}