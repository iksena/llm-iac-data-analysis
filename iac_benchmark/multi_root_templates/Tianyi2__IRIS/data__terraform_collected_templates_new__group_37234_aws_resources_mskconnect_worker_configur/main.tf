resource "aws_mskconnect_worker_configuration" "this" {
  name                    = var.name
  properties_file_content = var.properties_file_content
  region                  = var.region
  description             = var.description
  tags                    = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      delete = timeouts.value.delete
    }
  }
}