output "arn" {
  description = "Amazon Resource Name (ARN) of the endpoint."
  value       = aws_s3outposts_endpoint.this.arn
}

output "cidr_block" {
  description = "VPC CIDR block of the endpoint."
  value       = aws_s3outposts_endpoint.this.cidr_block
}

output "creation_time" {
  description = "UTC creation time in RFC3339 format."
  value       = aws_s3outposts_endpoint.this.creation_time
}

output "id" {
  description = "Amazon Resource Name (ARN) of the endpoint."
  value       = aws_s3outposts_endpoint.this.id
}

output "network_interfaces" {
  description = "Set of nested attributes for associated Elastic Network Interfaces (ENIs)."
  value       = aws_s3outposts_endpoint.this.network_interfaces
}