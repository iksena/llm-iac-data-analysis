resource "aws_iot_billing_group" "this" {
  region = var.region
  name   = var.name

  dynamic "properties" {
    for_each = var.properties != null ? [var.properties] : []
    content {
      description = properties.value.description
    }
  }

  tags = var.tags
}