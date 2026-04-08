output "id" {
  description = "API Key ID (Formatted as ApiId:Key)"
  value       = aws_appsync_api_key.this.id
}

output "key" {
  description = "API key"
  value       = aws_appsync_api_key.this.key
  sensitive   = true
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_appsync_api_key.this.region
}

output "api_id" {
  description = "ID of the associated AppSync API"
  value       = aws_appsync_api_key.this.api_id
}

output "description" {
  description = "API key description"
  value       = aws_appsync_api_key.this.description
}

output "expires" {
  description = "RFC3339 string representation of the expiry date"
  value       = aws_appsync_api_key.this.expires
}