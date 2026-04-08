resource "aws_vpc_ipam_scope" "this" {
  region      = var.region
  ipam_id     = var.ipam_id
  description = var.description
  tags        = var.tags
}