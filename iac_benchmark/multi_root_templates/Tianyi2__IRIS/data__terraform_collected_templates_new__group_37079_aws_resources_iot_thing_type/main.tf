resource "aws_iot_thing_type" "this" {
  region     = var.region
  name       = var.name
  deprecated = var.deprecated

  dynamic "properties" {
    for_each = var.properties != null ? [var.properties] : []
    content {
      description           = properties.value.description
      searchable_attributes = properties.value.searchable_attributes
    }
  }

  tags = var.tags
}