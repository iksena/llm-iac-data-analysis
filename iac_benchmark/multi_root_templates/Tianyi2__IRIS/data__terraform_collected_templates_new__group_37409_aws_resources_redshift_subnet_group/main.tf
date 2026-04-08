resource "aws_redshift_subnet_group" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  subnet_ids  = var.subnet_ids
  tags        = var.tags
}