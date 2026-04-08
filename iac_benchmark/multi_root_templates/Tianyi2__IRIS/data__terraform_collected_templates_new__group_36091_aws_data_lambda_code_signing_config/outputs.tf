output "arn" {
  description = "ARN of the code signing configuration"
  value       = data.aws_lambda_code_signing_config.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lambda_code_signing_config.this.region
}

output "allowed_publishers" {
  description = "List of allowed publishers as signing profiles for this code signing configuration"
  value       = data.aws_lambda_code_signing_config.this.allowed_publishers
}

output "config_id" {
  description = "Unique identifier for the code signing configuration"
  value       = data.aws_lambda_code_signing_config.this.config_id
}

output "description" {
  description = "Code signing configuration description"
  value       = data.aws_lambda_code_signing_config.this.description
}

output "last_modified" {
  description = "Date and time that the code signing configuration was last modified"
  value       = data.aws_lambda_code_signing_config.this.last_modified
}

output "policies" {
  description = "List of code signing policies that control the validation failure action for signature mismatch or expiry"
  value       = data.aws_lambda_code_signing_config.this.policies
}

output "allowed_publishers_signing_profile_version_arns" {
  description = "Set of ARNs for each of the signing profiles. A signing profile defines a trusted user who can sign a code package"
  value       = try(data.aws_lambda_code_signing_config.this.allowed_publishers[0].signing_profile_version_arns, [])
}

output "policies_untrusted_artifact_on_deployment" {
  description = "Code signing configuration policy for deployment validation failure. Valid values: Warn, Enforce"
  value       = try(data.aws_lambda_code_signing_config.this.policies[0].untrusted_artifact_on_deployment, null)
}