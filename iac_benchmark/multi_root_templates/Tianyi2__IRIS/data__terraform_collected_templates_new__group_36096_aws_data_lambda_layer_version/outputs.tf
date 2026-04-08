output "arn" {
  description = "ARN of the Lambda Layer with version"
  value       = data.aws_lambda_layer_version.this.arn
}

output "code_sha256" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = data.aws_lambda_layer_version.this.code_sha256
}

output "compatible_architectures" {
  description = "List of Architectures the specific Lambda Layer version is compatible with"
  value       = data.aws_lambda_layer_version.this.compatible_architectures
}

output "compatible_runtimes" {
  description = "List of Runtimes the specific Lambda Layer version is compatible with"
  value       = data.aws_lambda_layer_version.this.compatible_runtimes
}

output "created_date" {
  description = "Date this resource was created"
  value       = data.aws_lambda_layer_version.this.created_date
}

output "description" {
  description = "Description of the specific Lambda Layer version"
  value       = data.aws_lambda_layer_version.this.description
}

output "layer_arn" {
  description = "ARN of the Lambda Layer without version"
  value       = data.aws_lambda_layer_version.this.layer_arn
}

output "layer_name" {
  description = "Name of the Lambda layer"
  value       = data.aws_lambda_layer_version.this.layer_name
}

output "license_info" {
  description = "License info associated with the specific Lambda Layer version"
  value       = data.aws_lambda_layer_version.this.license_info
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lambda_layer_version.this.region
}

output "signing_job_arn" {
  description = "ARN of a signing job"
  value       = data.aws_lambda_layer_version.this.signing_job_arn
}

output "signing_profile_version_arn" {
  description = "ARN for a signing profile version"
  value       = data.aws_lambda_layer_version.this.signing_profile_version_arn
}

output "source_code_hash" {
  description = "Deprecated use code_sha256 instead - Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = data.aws_lambda_layer_version.this.source_code_hash
}

output "source_code_size" {
  description = "Size in bytes of the function .zip file"
  value       = data.aws_lambda_layer_version.this.source_code_size
}

output "version" {
  description = "Lambda Layer version"
  value       = data.aws_lambda_layer_version.this.version
}