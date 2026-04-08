resource "aws_glue_user_defined_function" "this" {
  region        = var.region
  name          = var.name
  catalog_id    = var.catalog_id
  database_name = var.database_name
  class_name    = var.class_name
  owner_name    = var.owner_name
  owner_type    = var.owner_type

  dynamic "resource_uris" {
    for_each = var.resource_uris != null ? var.resource_uris : []
    content {
      resource_type = resource_uris.value.resource_type
      uri           = resource_uris.value.uri
    }
  }
}