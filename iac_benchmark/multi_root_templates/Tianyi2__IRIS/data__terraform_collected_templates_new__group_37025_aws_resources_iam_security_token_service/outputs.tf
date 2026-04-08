output "id" {
  description = "The AWS Account ID"
  value       = aws_iam_security_token_service_preferences.this.id
}

output "global_endpoint_token_version" {
  description = "The version of the STS global endpoint token"
  value       = aws_iam_security_token_service_preferences.this.global_endpoint_token_version
}