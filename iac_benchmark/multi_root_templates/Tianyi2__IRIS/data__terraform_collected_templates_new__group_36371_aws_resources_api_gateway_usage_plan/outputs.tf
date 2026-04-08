output "id" {
  description = "ID of the API resource"
  value       = aws_api_gateway_usage_plan.this.id
}

output "name" {
  description = "Name of the usage plan."
  value       = aws_api_gateway_usage_plan.this.name
}

output "description" {
  description = "Description of a usage plan."
  value       = aws_api_gateway_usage_plan.this.description
}

output "api_stages" {
  description = "Associated API stages of the usage plan."
  value       = aws_api_gateway_usage_plan.this.api_stages
}

output "quota_settings" {
  description = "Quota of the usage plan."
  value       = aws_api_gateway_usage_plan.this.quota_settings
}

output "throttle_settings" {
  description = "Throttling limits of the usage plan."
  value       = aws_api_gateway_usage_plan.this.throttle_settings
}

output "product_code" {
  description = "AWS Marketplace product identifier to associate with the usage plan as a SaaS product on AWS Marketplace."
  value       = aws_api_gateway_usage_plan.this.product_code
}

output "arn" {
  description = "ARN"
  value       = aws_api_gateway_usage_plan.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_api_gateway_usage_plan.this.tags_all
}