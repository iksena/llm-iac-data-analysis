output "arn" {
  description = "ARN of the user pool"
  value       = aws_cognito_user_pool.this.arn
}

output "creation_date" {
  description = "Date the user pool was created"
  value       = aws_cognito_user_pool.this.creation_date
}

output "custom_domain" {
  description = "A custom domain name that you provide to Amazon Cognito"
  value       = aws_cognito_user_pool.this.custom_domain
}

output "domain" {
  description = "Holds the domain prefix if the user pool has a domain associated with it"
  value       = aws_cognito_user_pool.this.domain
}

output "endpoint" {
  description = "Endpoint name of the user pool"
  value       = aws_cognito_user_pool.this.endpoint
}

output "estimated_number_of_users" {
  description = "A number estimating the size of the user pool"
  value       = aws_cognito_user_pool.this.estimated_number_of_users
}

output "id" {
  description = "ID of the user pool"
  value       = aws_cognito_user_pool.this.id
}

output "last_modified_date" {
  description = "Date the user pool was last modified"
  value       = aws_cognito_user_pool.this.last_modified_date
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cognito_user_pool.this.tags_all
}