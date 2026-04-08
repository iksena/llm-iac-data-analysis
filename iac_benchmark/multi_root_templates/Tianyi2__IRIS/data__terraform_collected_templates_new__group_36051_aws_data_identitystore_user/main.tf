data "aws_identitystore_user" "this" {
  identity_store_id = var.identity_store_id
  region            = var.region
  user_id           = var.user_id

  dynamic "alternate_identifier" {
    for_each = var.alternate_identifier != null ? [var.alternate_identifier] : []
    content {
      dynamic "external_id" {
        for_each = alternate_identifier.value.external_id != null ? [alternate_identifier.value.external_id] : []
        content {
          id     = external_id.value.id
          issuer = external_id.value.issuer
        }
      }

      dynamic "unique_attribute" {
        for_each = alternate_identifier.value.unique_attribute != null ? [alternate_identifier.value.unique_attribute] : []
        content {
          attribute_path  = unique_attribute.value.attribute_path
          attribute_value = unique_attribute.value.attribute_value
        }
      }
    }
  }
}