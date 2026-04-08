output "arn" {
  description = "The Amazon Resource Name (ARN) for the signing profile."
  value       = aws_signer_signing_profile.this.arn
}

output "name" {
  description = "The name of the target signing profile."
  value       = aws_signer_signing_profile.this.name
}

output "platform_display_name" {
  description = "A human-readable name for the signing platform associated with the signing profile."
  value       = aws_signer_signing_profile.this.platform_display_name
}

output "revocation_record" {
  description = "Revocation information for a signing profile."
  value       = aws_signer_signing_profile.this.revocation_record
}

output "status" {
  description = "The status of the target signing profile."
  value       = aws_signer_signing_profile.this.status
}

output "version" {
  description = "The current version of the signing profile."
  value       = aws_signer_signing_profile.this.version
}

output "version_arn" {
  description = "The signing profile ARN, including the profile version."
  value       = aws_signer_signing_profile.this.version_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_signer_signing_profile.this.tags_all
}