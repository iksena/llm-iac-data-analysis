output "id" {
  description = "ID of a usage plan key."
  value       = aws_api_gateway_usage_plan_key.this.id
}

output "key_id" {
  description = "Identifier of the API gateway key resource."
  value       = aws_api_gateway_usage_plan_key.this.key_id
}

output "key_type" {
  description = "Type of a usage plan key. Currently, the valid key type is API_KEY."
  value       = aws_api_gateway_usage_plan_key.this.key_type
}

output "usage_plan_id" {
  description = "ID of the API resource."
  value       = aws_api_gateway_usage_plan_key.this.usage_plan_id
}

output "name" {
  description = "Name of a usage plan key."
  value       = aws_api_gateway_usage_plan_key.this.name
}

output "value" {
  description = "Value of a usage plan key."
  value       = aws_api_gateway_usage_plan_key.this.value
}