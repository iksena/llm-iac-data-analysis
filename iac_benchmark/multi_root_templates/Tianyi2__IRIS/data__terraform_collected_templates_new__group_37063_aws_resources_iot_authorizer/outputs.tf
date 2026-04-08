output "arn" {
  description = "The ARN of the authorizer."
  value       = aws_iot_authorizer.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iot_authorizer.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_iot_authorizer.this.region
}

output "authorizer_function_arn" {
  description = "The ARN of the authorizer's Lambda function."
  value       = aws_iot_authorizer.this.authorizer_function_arn
}

output "enable_caching_for_http" {
  description = "Specifies whether the HTTP caching is enabled or not."
  value       = aws_iot_authorizer.this.enable_caching_for_http
}

output "name" {
  description = "The name of the authorizer."
  value       = aws_iot_authorizer.this.name
}

output "signing_disabled" {
  description = "Specifies whether AWS IoT validates the token signature in an authorization request."
  value       = aws_iot_authorizer.this.signing_disabled
}

output "status" {
  description = "The status of Authorizer request at creation."
  value       = aws_iot_authorizer.this.status
}

output "tags" {
  description = "Map of tags assigned to this resource."
  value       = aws_iot_authorizer.this.tags
}

output "token_key_name" {
  description = "The name of the token key used to extract the token from the HTTP headers."
  value       = aws_iot_authorizer.this.token_key_name
}

output "token_signing_public_keys" {
  description = "The public keys used to verify the digital signature returned by your custom authentication service."
  value       = aws_iot_authorizer.this.token_signing_public_keys
}