resource "aws_servicecatalog_tag_option_resource_association" "this" {
  region        = var.region
  resource_id   = var.resource_id
  tag_option_id = var.tag_option_id

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}