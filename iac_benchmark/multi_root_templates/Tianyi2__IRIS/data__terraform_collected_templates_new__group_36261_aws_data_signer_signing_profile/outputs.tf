output "name" {
  description = "Name of the target signing profile"
  value       = data.aws_signer_signing_profile.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_signer_signing_profile.this.region
}

output "arn" {
  description = "ARN for the signing profile"
  value       = data.aws_signer_signing_profile.this.arn
}

output "platform_display_name" {
  description = "A human-readable name for the signing platform associated with the signing profile"
  value       = data.aws_signer_signing_profile.this.platform_display_name
}

output "platform_id" {
  description = "ID of the platform that is used by the target signing profile"
  value       = data.aws_signer_signing_profile.this.platform_id
}

output "revocation_record" {
  description = "Revocation information for a signing profile"
  value       = data.aws_signer_signing_profile.this.revocation_record
}

output "signature_validity_period" {
  description = "The validity period for a signing job"
  value       = data.aws_signer_signing_profile.this.signature_validity_period
}

output "signing_material" {
  description = "AWS Certificate Manager certificate that will be used to sign code with the new signing profile"
  value       = data.aws_signer_signing_profile.this.signing_material
}

output "signing_parameters" {
  description = "Map of key-value pairs for signing"
  value       = data.aws_signer_signing_profile.this.signing_parameters
}

output "status" {
  description = "Status of the target signing profile"
  value       = data.aws_signer_signing_profile.this.status
}

output "tags" {
  description = "List of tags associated with the signing profile"
  value       = data.aws_signer_signing_profile.this.tags
}

output "version" {
  description = "Current version of the signing profile"
  value       = data.aws_signer_signing_profile.this.version
}

output "version_arn" {
  description = "Signing profile ARN, including the profile version"
  value       = data.aws_signer_signing_profile.this.version_arn
}