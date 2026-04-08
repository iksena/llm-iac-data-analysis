output "id" {
  description = "Set to the ID of the API Key."
  value       = data.aws_api_gateway_api_key.this.id
}

output "name" {
  description = "Set to the name of the API Key."
  value       = data.aws_api_gateway_api_key.this.name
}

output "value" {
  description = "Set to the value of the API Key."
  value       = data.aws_api_gateway_api_key.this.value
  sensitive   = true
}

output "created_date" {
  description = "Date and time when the API Key was created."
  value       = data.aws_api_gateway_api_key.this.created_date
}

output "last_updated_date" {
  description = "Date and time when the API Key was last updated."
  value       = data.aws_api_gateway_api_key.this.last_updated_date
}

output "customer_id" {
  description = "Amazon Web Services Marketplace customer identifier, when integrating with the Amazon Web Services SaaS Marketplace."
  value       = data.aws_api_gateway_api_key.this.customer_id
}

output "description" {
  description = "Description of the API Key."
  value       = data.aws_api_gateway_api_key.this.description
}

output "enabled" {
  description = "Whether the API Key is enabled."
  value       = data.aws_api_gateway_api_key.this.enabled
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_api_gateway_api_key.this.tags
}