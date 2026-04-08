output "id" {
  description = "AWS Region."
  value       = data.aws_api_gateway_api_keys.this.id
}

output "items" {
  description = "List of objects containing API Key information."
  value       = data.aws_api_gateway_api_keys.this.items
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_api_gateway_api_keys.this.region
}

output "customer_id" {
  description = "Amazon Web Services Marketplace customer identifier, when integrating with the Amazon Web Services SaaS Marketplace."
  value       = data.aws_api_gateway_api_keys.this.customer_id
}

output "include_values" {
  description = "Set this value to true if you wish the result contains the key value."
  value       = data.aws_api_gateway_api_keys.this.include_values
}