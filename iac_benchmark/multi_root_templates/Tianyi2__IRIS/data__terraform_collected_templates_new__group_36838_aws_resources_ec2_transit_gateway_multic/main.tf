resource "aws_ec2_transit_gateway_multicast_domain_association" "this" {
  region                              = var.region
  subnet_id                           = var.subnet_id
  transit_gateway_attachment_id       = var.transit_gateway_attachment_id
  transit_gateway_multicast_domain_id = var.transit_gateway_multicast_domain_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}