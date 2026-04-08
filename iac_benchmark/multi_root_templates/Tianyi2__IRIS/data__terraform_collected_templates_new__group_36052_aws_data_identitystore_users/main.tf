data "aws_identitystore_users" "this" {
  region            = var.region
  identity_store_id = var.identity_store_id
}