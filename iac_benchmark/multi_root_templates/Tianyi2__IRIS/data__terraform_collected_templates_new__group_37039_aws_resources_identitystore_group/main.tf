resource "aws_identitystore_group" "this" {
  identity_store_id = var.identity_store_id
  region            = var.region
  display_name      = var.display_name
  description       = var.description
}