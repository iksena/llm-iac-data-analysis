output "id" {
  description = "The email identity."
  value       = aws_sesv2_email_identity_feedback_attributes.this.id
}

output "email_identity" {
  description = "The email identity."
  value       = aws_sesv2_email_identity_feedback_attributes.this.email_identity
}

output "email_forwarding_enabled" {
  description = "The feedback forwarding configuration for the identity."
  value       = aws_sesv2_email_identity_feedback_attributes.this.email_forwarding_enabled
}

output "region" {
  description = "The AWS region where the resource is managed."
  value       = aws_sesv2_email_identity_feedback_attributes.this.region
}