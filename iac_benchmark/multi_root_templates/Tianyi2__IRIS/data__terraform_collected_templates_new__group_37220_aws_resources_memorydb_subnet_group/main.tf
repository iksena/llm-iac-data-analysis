resource "aws_memorydb_subnet_group" "this" {
  subnet_ids = var.subnet_ids

  name        = var.name
  name_prefix = var.name_prefix
  description = var.description
  region      = var.region
  tags        = var.tags
}