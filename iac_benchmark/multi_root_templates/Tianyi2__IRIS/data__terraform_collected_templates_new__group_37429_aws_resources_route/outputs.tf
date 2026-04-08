output "id" {
  description = "Route identifier computed from the routing table identifier and route destination."
  value       = aws_route.this.id
}

output "instance_id" {
  description = "Identifier of an EC2 instance."
  value       = aws_route.this.instance_id
}

output "instance_owner_id" {
  description = "The AWS account ID of the owner of the EC2 instance."
  value       = aws_route.this.instance_owner_id
}

output "origin" {
  description = "How the route was created - CreateRouteTable, CreateRoute or EnableVgwRoutePropagation."
  value       = aws_route.this.origin
}

output "state" {
  description = "The state of the route - active or blackhole."
  value       = aws_route.this.state
}

# Additional outputs for all configured arguments (as mentioned in the documentation that only configured arguments will be exported)
output "region" {
  description = "Region where this resource is managed."
  value       = aws_route.this.region
}

output "route_table_id" {
  description = "The ID of the routing table."
  value       = aws_route.this.route_table_id
}

output "destination_cidr_block" {
  description = "The destination CIDR block."
  value       = aws_route.this.destination_cidr_block
}

output "destination_ipv6_cidr_block" {
  description = "The destination IPv6 CIDR block."
  value       = aws_route.this.destination_ipv6_cidr_block
}

output "destination_prefix_list_id" {
  description = "The ID of a managed prefix list destination."
  value       = aws_route.this.destination_prefix_list_id
}

output "carrier_gateway_id" {
  description = "Identifier of a carrier gateway."
  value       = aws_route.this.carrier_gateway_id
}

output "core_network_arn" {
  description = "The Amazon Resource Name (ARN) of a core network."
  value       = aws_route.this.core_network_arn
}

output "egress_only_gateway_id" {
  description = "Identifier of a VPC Egress Only Internet Gateway."
  value       = aws_route.this.egress_only_gateway_id
}

output "gateway_id" {
  description = "Identifier of a VPC internet gateway or a virtual private gateway."
  value       = aws_route.this.gateway_id
}

output "nat_gateway_id" {
  description = "Identifier of a VPC NAT gateway."
  value       = aws_route.this.nat_gateway_id
}

output "local_gateway_id" {
  description = "Identifier of a Outpost local gateway."
  value       = aws_route.this.local_gateway_id
}

output "network_interface_id" {
  description = "Identifier of an EC2 network interface."
  value       = aws_route.this.network_interface_id
}

output "transit_gateway_id" {
  description = "Identifier of an EC2 Transit Gateway."
  value       = aws_route.this.transit_gateway_id
}

output "vpc_endpoint_id" {
  description = "Identifier of a VPC Endpoint."
  value       = aws_route.this.vpc_endpoint_id
}

output "vpc_peering_connection_id" {
  description = "Identifier of a VPC peering connection."
  value       = aws_route.this.vpc_peering_connection_id
}