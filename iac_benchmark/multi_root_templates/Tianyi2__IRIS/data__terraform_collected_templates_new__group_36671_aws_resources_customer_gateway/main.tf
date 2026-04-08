resource "aws_customer_gateway" "this" {
  bgp_asn          = var.bgp_asn
  bgp_asn_extended = var.bgp_asn_extended
  certificate_arn  = var.certificate_arn
  device_name      = var.device_name
  ip_address       = var.ip_address
  type             = var.type
  tags             = var.tags
}