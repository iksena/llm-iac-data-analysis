resource "aws_vpc_endpoint_private_dns" "this" {
  region              = var.region
  private_dns_enabled = var.private_dns_enabled
  vpc_endpoint_id     = var.vpc_endpoint_id
}