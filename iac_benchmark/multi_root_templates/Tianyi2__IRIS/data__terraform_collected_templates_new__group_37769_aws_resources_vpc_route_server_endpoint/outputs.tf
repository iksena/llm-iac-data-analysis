output "arn" {
  description = "The ARN of the route server endpoint"
  value       = aws_vpc_route_server_endpoint.this.arn
}

output "route_server_endpoint_id" {
  description = "The unique identifier of the route server endpoint"
  value       = aws_vpc_route_server_endpoint.this.route_server_endpoint_id
}

output "eni_id" {
  description = "The ID of the Elastic network interface for the endpoint"
  value       = aws_vpc_route_server_endpoint.this.eni_id
}

output "eni_address" {
  description = "The IP address of the Elastic network interface for the endpoint"
  value       = aws_vpc_route_server_endpoint.this.eni_address
}

output "vpc_id" {
  description = "The ID of the VPC containing the endpoint"
  value       = aws_vpc_route_server_endpoint.this.vpc_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpc_route_server_endpoint.this.tags_all
}