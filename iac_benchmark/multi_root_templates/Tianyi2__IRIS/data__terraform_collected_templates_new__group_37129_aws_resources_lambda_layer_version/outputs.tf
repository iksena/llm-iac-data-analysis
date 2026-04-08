output "arn" {
  description = "ARN of the Lambda Layer with version"
  value       = aws_lambda_layer_version.this.arn
}

output "code_sha256" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = aws_lambda_layer_version.this.code_sha256
}

output "created_date" {
  description = "Date this resource was created"
  value       = aws_lambda_layer_version.this.created_date
}

output "layer_arn" {
  description = "ARN of the Lambda Layer without version"
  value       = aws_lambda_layer_version.this.layer_arn
}

output "signing_job_arn" {
  description = "ARN of a signing job"
  value       = aws_lambda_layer_version.this.signing_job_arn
}

output "signing_profile_version_arn" {
  description = "ARN for a signing profile version"
  value       = aws_lambda_layer_version.this.signing_profile_version_arn
}

output "source_code_size" {
  description = "Size in bytes of the function .zip file"
  value       = aws_lambda_layer_version.this.source_code_size
}

output "version" {
  description = "Lambda Layer version"
  value       = aws_lambda_layer_version.this.version
}