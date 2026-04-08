resource "aws_docdb_subnet_group" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  description = var.description
  subnet_ids  = var.subnet_ids
  tags        = var.tags
}