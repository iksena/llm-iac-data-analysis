output "id" {
  description = "ID of the API key"
  value       = aws_api_gateway_api_key.this.id
}

output "created_date" {
  description = "Creation date of the API key"
  value       = aws_api_gateway_api_key.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the API key"
  value       = aws_api_gateway_api_key.this.last_updated_date
}

output "arn" {
  description = "ARN"
  value       = aws_api_gateway_api_key.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_api_gateway_api_key.this.tags_all
}