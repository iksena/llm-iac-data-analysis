resource "aws_location_place_index" "this" {
  data_source = var.data_source
  index_name  = var.index_name

  description = var.description
  tags        = var.tags

  dynamic "data_source_configuration" {
    for_each = var.data_source_configuration != null ? [var.data_source_configuration] : []
    content {
      intended_use = data_source_configuration.value.intended_use
    }
  }
}