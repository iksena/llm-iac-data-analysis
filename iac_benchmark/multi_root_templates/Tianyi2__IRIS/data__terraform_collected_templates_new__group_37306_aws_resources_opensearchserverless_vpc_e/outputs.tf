output "id" {
  description = "Unique identifier of the VPC Endpoint."
  value       = aws_opensearchserverless_vpc_endpoint.this.id
}

output "name" {
  description = "Name of the interface endpoint."
  value       = aws_opensearchserverless_vpc_endpoint.this.name
}

output "subnet_ids" {
  description = "Subnet IDs from which you'll access OpenSearch Serverless."
  value       = aws_opensearchserverless_vpc_endpoint.this.subnet_ids
}

output "vpc_id" {
  description = "ID of the VPC from which you'll access OpenSearch Serverless."
  value       = aws_opensearchserverless_vpc_endpoint.this.vpc_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_opensearchserverless_vpc_endpoint.this.region
}

output "security_group_ids" {
  description = "Security groups that define the ports, protocols, and sources for inbound traffic."
  value       = aws_opensearchserverless_vpc_endpoint.this.security_group_ids
}