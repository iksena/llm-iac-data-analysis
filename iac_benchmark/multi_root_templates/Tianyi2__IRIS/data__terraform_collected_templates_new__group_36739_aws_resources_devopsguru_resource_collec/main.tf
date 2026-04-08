resource "aws_devopsguru_resource_collection" "this" {
  type   = var.type
  region = var.region

  dynamic "cloudformation" {
    for_each = var.cloudformation != null ? [var.cloudformation] : []
    content {
      stack_names = cloudformation.value.stack_names
    }
  }

  dynamic "tags" {
    for_each = var.tags != null ? [var.tags] : []
    content {
      app_boundary_key = tags.value.app_boundary_key
      tag_values       = tags.value.tag_values
    }
  }
}