output "creation_time" {
  description = "The time that the Verified Access Instance was created."
  value       = aws_verifiedaccess_instance.this.creation_time
}

output "id" {
  description = "The ID of the AWS Verified Access Instance."
  value       = aws_verifiedaccess_instance.this.id
}

output "last_updated_time" {
  description = "The time that the Verified Access Instance was last updated."
  value       = aws_verifiedaccess_instance.this.last_updated_time
}

output "verified_access_trust_providers" {
  description = "One or more blocks of providing information about the AWS Verified Access Trust Providers."
  value       = aws_verifiedaccess_instance.this.verified_access_trust_providers
}