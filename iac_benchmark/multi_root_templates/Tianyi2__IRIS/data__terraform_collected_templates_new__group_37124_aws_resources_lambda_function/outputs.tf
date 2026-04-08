output "arn" {
  description = "ARN identifying your Lambda Function."
  value       = aws_lambda_function.this.arn
}

output "code_sha256" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file."
  value       = aws_lambda_function.this.code_sha256
}

output "invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri."
  value       = aws_lambda_function.this.invoke_arn
}

output "last_modified" {
  description = "Date this resource was last modified."
  value       = aws_lambda_function.this.last_modified
}

output "qualified_arn" {
  description = "ARN identifying your Lambda Function Version (if versioning is enabled via publish = true)."
  value       = aws_lambda_function.this.qualified_arn
}

output "qualified_invoke_arn" {
  description = "Qualified ARN (ARN with lambda version number) to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri."
  value       = aws_lambda_function.this.qualified_invoke_arn
}

output "signing_job_arn" {
  description = "ARN of the signing job."
  value       = aws_lambda_function.this.signing_job_arn
}

output "signing_profile_version_arn" {
  description = "ARN of the signing profile version."
  value       = aws_lambda_function.this.signing_profile_version_arn
}

output "source_code_size" {
  description = "Size in bytes of the function .zip file."
  value       = aws_lambda_function.this.source_code_size
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_lambda_function.this.tags_all
}

output "version" {
  description = "Latest published version of your Lambda Function."
  value       = aws_lambda_function.this.version
}

output "snap_start_optimization_status" {
  description = "Optimization status of the snap start configuration. Valid values are On and Off."
  value       = try(aws_lambda_function.this.snap_start[0].optimization_status, null)
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = try(aws_lambda_function.this.vpc_config[0].vpc_id, null)
}