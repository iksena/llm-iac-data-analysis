resource "aws_route53_cidr_location" "this" {
  cidr_blocks        = var.cidr_blocks
  cidr_collection_id = var.cidr_collection_id
  name               = var.name
}