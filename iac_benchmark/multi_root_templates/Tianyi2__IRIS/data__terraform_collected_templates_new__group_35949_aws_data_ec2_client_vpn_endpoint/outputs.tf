output "arn" {
  description = "The ARN of the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.arn
}

output "authentication_options" {
  description = "Information about the authentication method used by the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.authentication_options
}

output "client_cidr_block" {
  description = "IPv4 address range, in CIDR notation, from which client IP addresses are assigned."
  value       = data.aws_ec2_client_vpn_endpoint.this.client_cidr_block
}

output "client_connect_options" {
  description = "The options for managing connection authorization for new client connections."
  value       = data.aws_ec2_client_vpn_endpoint.this.client_connect_options
}

output "client_login_banner_options" {
  description = "Options for enabling a customizable text banner that will be displayed on AWS provided clients when a VPN session is established."
  value       = data.aws_ec2_client_vpn_endpoint.this.client_login_banner_options
}

output "client_route_enforcement_options" {
  description = "Options for enforce administrator defined routes on devices connected through the VPN."
  value       = data.aws_ec2_client_vpn_endpoint.this.client_route_enforcement_options
}

output "connection_log_options" {
  description = "Information about the client connection logging options for the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.connection_log_options
}

output "description" {
  description = "Brief description of the endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.description
}

output "dns_name" {
  description = "DNS name to be used by clients when connecting to the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.dns_name
}

output "dns_servers" {
  description = "Information about the DNS servers to be used for DNS resolution."
  value       = data.aws_ec2_client_vpn_endpoint.this.dns_servers
}

output "endpoint_ip_address_type" {
  description = "IP address type for the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.endpoint_ip_address_type
}

output "security_group_ids" {
  description = "IDs of the security groups for the target network associated with the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.security_group_ids
}

output "self_service_portal" {
  description = "Whether the self-service portal for the Client VPN endpoint is enabled."
  value       = data.aws_ec2_client_vpn_endpoint.this.self_service_portal
}

output "self_service_portal_url" {
  description = "The URL of the self-service portal."
  value       = data.aws_ec2_client_vpn_endpoint.this.self_service_portal_url
}

output "server_certificate_arn" {
  description = "The ARN of the server certificate."
  value       = data.aws_ec2_client_vpn_endpoint.this.server_certificate_arn
}

output "session_timeout_hours" {
  description = "The maximum VPN session duration time in hours."
  value       = data.aws_ec2_client_vpn_endpoint.this.session_timeout_hours
}

output "split_tunnel" {
  description = "Whether split-tunnel is enabled in the AWS Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.split_tunnel
}

output "traffic_ip_address_type" {
  description = "IP address type for traffic within the Client VPN tunnel."
  value       = data.aws_ec2_client_vpn_endpoint.this.traffic_ip_address_type
}

output "transport_protocol" {
  description = "Transport protocol used by the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.transport_protocol
}

output "vpc_id" {
  description = "ID of the VPC associated with the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.vpc_id
}

output "vpn_port" {
  description = "Port number for the Client VPN endpoint."
  value       = data.aws_ec2_client_vpn_endpoint.this.vpn_port
}