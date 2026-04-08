# Client VPN Resources
resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
  count                  = local.create_private_resources ? 1 : 0
  description            = "${var.env}-client-vpn-endpoint"
  client_cidr_block      = var.client_vpn_cidr_block
  split_tunnel           = true
  server_certificate_arn = var.vpn_server_cert_arn
  security_group_ids     = [aws_security_group.private_sg[0].id]
  vpc_id                 = var.vpc_id
  transport_protocol     = "udp"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.vpn_client_cert_arn
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name        = "${var.env}-client-vpn"
    Environment = var.env
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_associations" {
  count                  = local.create_private_resources ? length(var.private_subnet_ids) : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint[0].id
  subnet_id              = var.private_subnet_ids[count.index]
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  count                  = local.create_private_resources ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint[0].id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true

  depends_on = [aws_ec2_client_vpn_network_association.vpn_associations]
}