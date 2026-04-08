output "arn" {
  description = "ARN of the Email Identity"
  value       = data.aws_sesv2_email_identity.this.arn
}

output "dkim_signing_attributes" {
  description = "A list of objects that contains at most one element with information about the private key and selector that you want to use to configure DKIM for the identity for Bring Your Own DKIM (BYODKIM) for the identity, or, configures the key length to be used for Easy DKIM"
  value       = data.aws_sesv2_email_identity.this.dkim_signing_attributes
}

output "identity_type" {
  description = "The email identity type. Valid values: EMAIL_ADDRESS, DOMAIN"
  value       = data.aws_sesv2_email_identity.this.identity_type
}

output "tags" {
  description = "Key-value mapping of resource tags"
  value       = data.aws_sesv2_email_identity.this.tags
}

output "verification_status" {
  description = "The verification status of the identity. The status can be one of the following: PENDING, SUCCESS, FAILED, TEMPORARY_FAILURE, and NOT_STARTED"
  value       = data.aws_sesv2_email_identity.this.verification_status
}

output "verified_for_sending_status" {
  description = "Specifies whether or not the identity is verified"
  value       = data.aws_sesv2_email_identity.this.verified_for_sending_status
}