output "id" {
  description = "The ID of the Client VPN authorization rule"
  value       = aws_ec2_client_vpn_authorization_rule.this.id
}

output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_authorization_rule.this.client_vpn_endpoint_id
}

output "target_network_cidr" {
  description = "The IPv4 address range, in CIDR notation, of the network to which the authorization rule applies"
  value       = aws_ec2_client_vpn_authorization_rule.this.target_network_cidr
}

output "access_group_id" {
  description = "The ID of the group to which the authorization rule grants access"
  value       = aws_ec2_client_vpn_authorization_rule.this.access_group_id
}

output "authorize_all_groups" {
  description = "Indicates whether the authorization rule grants access to all clients"
  value       = aws_ec2_client_vpn_authorization_rule.this.authorize_all_groups
}

output "description" {
  description = "A brief description of the authorization rule"
  value       = aws_ec2_client_vpn_authorization_rule.this.description
}