resource "aws_memorydb_acl" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  user_names  = var.user_names
  tags        = var.tags
}