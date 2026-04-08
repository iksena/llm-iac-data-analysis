output "architectures" {
  description = "Instruction set architecture for the Lambda function."
  value       = data.aws_lambda_function.this.architectures
}

output "arn" {
  description = "Unqualified (no :QUALIFIER or :VERSION suffix) ARN identifying your Lambda Function."
  value       = data.aws_lambda_function.this.arn
}

output "code_sha256" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file."
  value       = data.aws_lambda_function.this.code_sha256
}

output "code_signing_config_arn" {
  description = "ARN for a Code Signing Configuration."
  value       = data.aws_lambda_function.this.code_signing_config_arn
}

output "dead_letter_config" {
  description = "Configuration for the function's dead letter queue."
  value       = data.aws_lambda_function.this.dead_letter_config
}

output "description" {
  description = "Description of what your Lambda Function does."
  value       = data.aws_lambda_function.this.description
}

output "environment" {
  description = "Lambda environment's configuration settings."
  value       = data.aws_lambda_function.this.environment
}

output "ephemeral_storage" {
  description = "Amount of ephemeral storage (/tmp) allocated for the Lambda Function."
  value       = data.aws_lambda_function.this.ephemeral_storage
}

output "file_system_config" {
  description = "Connection settings for an Amazon EFS file system."
  value       = data.aws_lambda_function.this.file_system_config
}

output "function_name" {
  description = "Name of the Lambda function."
  value       = data.aws_lambda_function.this.function_name
}

output "handler" {
  description = "Function entrypoint in your code."
  value       = data.aws_lambda_function.this.handler
}

output "image_uri" {
  description = "URI of the container image."
  value       = data.aws_lambda_function.this.image_uri
}

output "invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway."
  value       = data.aws_lambda_function.this.invoke_arn
}

output "kms_key_arn" {
  description = "ARN for the KMS encryption key."
  value       = data.aws_lambda_function.this.kms_key_arn
}

output "last_modified" {
  description = "Date this resource was last modified."
  value       = data.aws_lambda_function.this.last_modified
}

output "layers" {
  description = "List of Lambda Layer ARNs attached to your Lambda Function."
  value       = data.aws_lambda_function.this.layers
}

output "logging_config" {
  description = "Advanced logging settings."
  value       = data.aws_lambda_function.this.logging_config
}

output "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  value       = data.aws_lambda_function.this.memory_size
}

output "qualified_arn" {
  description = "Qualified (:QUALIFIER or :VERSION suffix) ARN identifying your Lambda Function."
  value       = data.aws_lambda_function.this.qualified_arn
}

output "qualified_invoke_arn" {
  description = "Qualified (:QUALIFIER or :VERSION suffix) ARN to be used for invoking Lambda Function from API Gateway."
  value       = data.aws_lambda_function.this.qualified_invoke_arn
}

output "qualifier" {
  description = "Alias name or version number of the Lambda function."
  value       = data.aws_lambda_function.this.qualifier
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_lambda_function.this.region
}

output "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this Lambda function or -1 if unreserved."
  value       = data.aws_lambda_function.this.reserved_concurrent_executions
}

output "role" {
  description = "IAM role attached to the Lambda Function."
  value       = data.aws_lambda_function.this.role
}

output "runtime" {
  description = "Runtime environment for the Lambda function."
  value       = data.aws_lambda_function.this.runtime
}

output "signing_job_arn" {
  description = "ARN of a signing job."
  value       = data.aws_lambda_function.this.signing_job_arn
}

output "signing_profile_version_arn" {
  description = "ARN for a signing profile version."
  value       = data.aws_lambda_function.this.signing_profile_version_arn
}

output "source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file."
  value       = data.aws_lambda_function.this.source_code_hash
}

output "source_code_size" {
  description = "Size in bytes of the function .zip file."
  value       = data.aws_lambda_function.this.source_code_size
}

output "source_kms_key_arn" {
  description = "ARN of the AWS Key Management Service key used to encrypt the function's .zip deployment package."
  value       = data.aws_lambda_function.this.source_kms_key_arn
}

output "tags" {
  description = "Map of tags assigned to the Lambda Function."
  value       = data.aws_lambda_function.this.tags
}

output "timeout" {
  description = "Function execution time at which Lambda should terminate the function."
  value       = data.aws_lambda_function.this.timeout
}

output "tracing_config" {
  description = "Tracing settings of the function."
  value       = data.aws_lambda_function.this.tracing_config
}

output "version" {
  description = "Version of the Lambda function returned."
  value       = data.aws_lambda_function.this.version
}

output "vpc_config" {
  description = "VPC configuration associated with your Lambda function."
  value       = data.aws_lambda_function.this.vpc_config
}