data "aws_vpc_ipam" "this" {
  id     = var.id
  region = var.region
}