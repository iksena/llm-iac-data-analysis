output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_opensearchserverless_vpc_endpoint.this.region
}

output "vpc_endpoint_id" {
  description = "The unique identifier of the endpoint."
  value       = data.aws_opensearchserverless_vpc_endpoint.this.vpc_endpoint_id
}

output "created_date" {
  description = "The date the endpoint was created."
  value       = data.aws_opensearchserverless_vpc_endpoint.this.created_date
}

output "name" {
  description = "The name of the endpoint."
  value       = data.aws_opensearchserverless_vpc_endpoint.this.name
}

output "security_group_ids" {
  description = "The IDs of the security groups that define the ports, protocols, and sources for inbound traffic that you are authorizing into your endpoint."
  value       = data.aws_opensearchserverless_vpc_endpoint.this.security_group_ids
}

output "subnet_ids" {
  description = "The IDs of the subnets from which you access OpenSearch Serverless."
  value       = data.aws_opensearchserverless_vpc_endpoint.this.subnet_ids
}

output "vpc_id" {
  description = "The ID of the VPC from which you access OpenSearch Serverless."
  value       = data.aws_opensearchserverless_vpc_endpoint.this.vpc_id
}