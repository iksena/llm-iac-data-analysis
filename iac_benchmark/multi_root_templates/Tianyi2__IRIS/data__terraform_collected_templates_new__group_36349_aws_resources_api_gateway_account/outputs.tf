output "api_key_version" {
  description = "The version of the API keys used for the account."
  value       = aws_api_gateway_account.this.api_key_version
}

output "throttle_settings" {
  description = "Account-Level throttle settings."
  value       = aws_api_gateway_account.this.throttle_settings
}

output "throttle_settings_burst_limit" {
  description = "Absolute maximum number of times API Gateway allows the API to be called per second (RPS)."
  value       = try(aws_api_gateway_account.this.throttle_settings[0].burst_limit, null)
}

output "throttle_settings_rate_limit" {
  description = "Number of times API Gateway allows the API to be called per second on average (RPS)."
  value       = try(aws_api_gateway_account.this.throttle_settings[0].rate_limit, null)
}

output "features" {
  description = "A list of features supported for the account."
  value       = aws_api_gateway_account.this.features
}