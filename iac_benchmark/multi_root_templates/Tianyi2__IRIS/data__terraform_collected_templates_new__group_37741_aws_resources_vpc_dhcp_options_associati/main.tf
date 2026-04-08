resource "aws_vpc_dhcp_options_association" "this" {
  region          = var.region
  vpc_id          = var.vpc_id
  dhcp_options_id = var.dhcp_options_id
}