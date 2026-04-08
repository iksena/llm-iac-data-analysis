output "id" {
  description = "VPC Link identifier."
  value       = aws_apigatewayv2_vpc_link.this.id
}

output "arn" {
  description = "VPC Link ARN."
  value       = aws_apigatewayv2_vpc_link.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_apigatewayv2_vpc_link.this.tags_all
}