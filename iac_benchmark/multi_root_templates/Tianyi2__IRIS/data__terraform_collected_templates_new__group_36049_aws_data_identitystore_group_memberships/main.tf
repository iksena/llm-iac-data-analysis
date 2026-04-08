data "aws_identitystore_group_memberships" "this" {
  region            = var.region
  group_id          = var.group_id
  identity_store_id = var.identity_store_id
}