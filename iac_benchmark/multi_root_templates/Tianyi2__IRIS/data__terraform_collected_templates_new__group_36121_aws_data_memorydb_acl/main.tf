data "aws_memorydb_acl" "this" {
  name   = var.name
  region = var.region
}