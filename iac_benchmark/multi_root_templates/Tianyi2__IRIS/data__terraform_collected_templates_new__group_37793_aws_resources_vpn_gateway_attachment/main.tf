resource "aws_vpn_gateway_attachment" "this" {
  region         = var.region
  vpc_id         = var.vpc_id
  vpn_gateway_id = var.vpn_gateway_id
}