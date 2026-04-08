output "id" {
  description = "The ID of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_route.this.id
}

output "origin" {
  description = "Indicates how the Client VPN route was added. Will be `add-route` for routes created by this resource"
  value       = aws_ec2_client_vpn_route.this.origin
}

output "type" {
  description = "The type of the route"
  value       = aws_ec2_client_vpn_route.this.type
}

output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_route.this.client_vpn_endpoint_id
}

output "destination_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, of the route destination"
  value       = aws_ec2_client_vpn_route.this.destination_cidr_block
}

output "target_vpc_subnet_id" {
  description = "The ID of the Subnet to route the traffic through"
  value       = aws_ec2_client_vpn_route.this.target_vpc_subnet_id
}

output "description" {
  description = "A brief description of the route"
  value       = aws_ec2_client_vpn_route.this.description
}