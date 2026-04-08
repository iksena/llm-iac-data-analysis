output "arn" {
  description = "The ARN of the route server peer."
  value       = aws_vpc_route_server_peer.this.arn
}

output "route_server_peer_id" {
  description = "The unique identifier of the route server peer."
  value       = aws_vpc_route_server_peer.this.route_server_peer_id
}

output "route_server_id" {
  description = "The ID of the route server associated with this peer."
  value       = aws_vpc_route_server_peer.this.route_server_id
}

output "endpoint_eni_address" {
  description = "The IP address of the Elastic network interface for the route server endpoint."
  value       = aws_vpc_route_server_peer.this.endpoint_eni_address
}

output "endpoint_eni_id" {
  description = "The ID of the Elastic network interface for the route server endpoint."
  value       = aws_vpc_route_server_peer.this.endpoint_eni_id
}

output "subnet_id" {
  description = "The ID of the subnet containing the route server peer."
  value       = aws_vpc_route_server_peer.this.subnet_id
}

output "vpc_id" {
  description = "The ID of the VPC containing the route server peer."
  value       = aws_vpc_route_server_peer.this.vpc_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_route_server_peer.this.tags_all
}