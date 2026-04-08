output "arn" {
  description = "ARN of the VPC Link."
  value       = data.aws_apigatewayv2_vpc_link.this.arn
}

output "id" {
  description = "VPC Link ID."
  value       = data.aws_apigatewayv2_vpc_link.this.id
}

output "name" {
  description = "VPC Link Name."
  value       = data.aws_apigatewayv2_vpc_link.this.name
}

output "security_group_ids" {
  description = "List of security groups associated with the VPC Link."
  value       = data.aws_apigatewayv2_vpc_link.this.security_group_ids
}

output "subnet_ids" {
  description = "List of subnets attached to the VPC Link."
  value       = data.aws_apigatewayv2_vpc_link.this.subnet_ids
}

output "tags" {
  description = "VPC Link Tags."
  value       = data.aws_apigatewayv2_vpc_link.this.tags
}