output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_codeartifact_authorization_token.this.region
}

output "domain" {
  description = "Name of the domain that is in scope for the generated authorization token."
  value       = data.aws_codeartifact_authorization_token.this.domain
}

output "domain_owner" {
  description = "Account number of the AWS account that owns the domain."
  value       = data.aws_codeartifact_authorization_token.this.domain_owner
}

output "duration_seconds" {
  description = "Time, in seconds, that the generated authorization token is valid."
  value       = data.aws_codeartifact_authorization_token.this.duration_seconds
}

output "authorization_token" {
  description = "Temporary authorization token."
  value       = data.aws_codeartifact_authorization_token.this.authorization_token
  sensitive   = true
}

output "expiration" {
  description = "Time in UTC RFC3339 format when the authorization token expires."
  value       = data.aws_codeartifact_authorization_token.this.expiration
}