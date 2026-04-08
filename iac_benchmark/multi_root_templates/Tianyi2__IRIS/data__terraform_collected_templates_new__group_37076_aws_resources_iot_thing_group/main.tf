resource "aws_iot_thing_group" "this" {
  region            = var.region
  name              = var.name
  parent_group_name = var.parent_group_name

  dynamic "properties" {
    for_each = var.properties != null ? [var.properties] : []
    content {
      description = properties.value.description

      dynamic "attribute_payload" {
        for_each = properties.value.attribute_payload != null ? [properties.value.attribute_payload] : []
        content {
          attributes = attribute_payload.value.attributes
        }
      }
    }
  }

  tags = var.tags
}