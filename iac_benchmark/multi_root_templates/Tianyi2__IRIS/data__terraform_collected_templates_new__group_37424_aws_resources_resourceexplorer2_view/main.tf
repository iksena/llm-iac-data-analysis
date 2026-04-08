resource "aws_resourceexplorer2_view" "this" {
  region       = var.region
  default_view = var.default_view
  name         = var.name
  scope        = var.scope
  tags         = var.tags

  dynamic "filters" {
    for_each = var.filters != null ? [var.filters] : []
    content {
      filter_string = filters.value.filter_string
    }
  }

  dynamic "included_property" {
    for_each = var.included_properties
    content {
      name = included_property.value.name
    }
  }
}