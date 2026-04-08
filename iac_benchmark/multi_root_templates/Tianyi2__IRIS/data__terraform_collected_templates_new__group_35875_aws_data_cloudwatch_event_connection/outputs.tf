output "arn" {
  description = "ARN (Amazon Resource Name) of the connection"
  value       = data.aws_cloudwatch_event_connection.this.arn
}

output "authorization_type" {
  description = "Type of authorization specified for the connection. One of API_KEY, BASIC, OAUTH_CLIENT_CREDENTIALS"
  value       = data.aws_cloudwatch_event_connection.this.authorization_type
}

output "kms_key_identifier" {
  description = "Identifier of the AWS KMS customer managed key for EventBridge to use to encrypt the connection, if one has been specified"
  value       = data.aws_cloudwatch_event_connection.this.kms_key_identifier
}

output "secret_arn" {
  description = "ARN of the secret created from the authorization parameters specified for the connection"
  value       = data.aws_cloudwatch_event_connection.this.secret_arn
}

output "name" {
  description = "Name of the connection"
  value       = data.aws_cloudwatch_event_connection.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_cloudwatch_event_connection.this.region
}