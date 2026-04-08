output "arn" {
  description = "ARN of the VPC Connection"
  value       = data.aws_msk_vpc_connection.this.arn
}

output "authentication" {
  description = "The authentication type for the client VPC Connection"
  value       = data.aws_msk_vpc_connection.this.authentication
}

output "client_subnets" {
  description = "The list of subnets in the client VPC"
  value       = data.aws_msk_vpc_connection.this.client_subnets
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_msk_vpc_connection.this.region
}

output "security_groups" {
  description = "The security groups attached to the ENIs for the broker nodes"
  value       = data.aws_msk_vpc_connection.this.security_groups
}

output "tags" {
  description = "Map of key-value pairs assigned to the VPC Connection"
  value       = data.aws_msk_vpc_connection.this.tags
}

output "target_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = data.aws_msk_vpc_connection.this.target_cluster_arn
}

output "vpc_id" {
  description = "The VPC ID of the remote client"
  value       = data.aws_msk_vpc_connection.this.vpc_id
}