resource "aws_ec2_client_vpn_network_association" "this" {
  region                 = var.region
  client_vpn_endpoint_id = var.client_vpn_endpoint_id
  subnet_id              = var.subnet_id

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}