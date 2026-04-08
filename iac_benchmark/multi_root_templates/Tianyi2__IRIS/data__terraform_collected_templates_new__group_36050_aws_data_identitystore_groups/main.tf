data "aws_identitystore_groups" "this" {
  region            = var.region
  identity_store_id = var.identity_store_id
}