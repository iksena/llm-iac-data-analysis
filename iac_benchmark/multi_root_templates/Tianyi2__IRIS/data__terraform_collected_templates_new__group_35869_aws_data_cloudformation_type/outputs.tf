output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_cloudformation_type.this.region
}

output "arn" {
  description = "ARN of the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.arn
}

output "type" {
  description = "CloudFormation Registry Type."
  value       = data.aws_cloudformation_type.this.type
}

output "type_name" {
  description = "CloudFormation Type name."
  value       = data.aws_cloudformation_type.this.type_name
}

output "version_id" {
  description = "Identifier of the CloudFormation Type version."
  value       = data.aws_cloudformation_type.this.version_id
}

output "default_version_id" {
  description = "Identifier of the CloudFormation Type default version."
  value       = data.aws_cloudformation_type.this.default_version_id
}

output "deprecated_status" {
  description = "Deprecation status of the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.deprecated_status
}

output "description" {
  description = "Description of the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.description
}

output "documentation_url" {
  description = "URL of the documentation for the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.documentation_url
}

output "execution_role_arn" {
  description = "ARN of the IAM Role used to register the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.execution_role_arn
}

output "is_default_version" {
  description = "Whether the CloudFormation Type version is the default version."
  value       = data.aws_cloudformation_type.this.is_default_version
}

output "logging_config" {
  description = "List of objects containing logging configuration."
  value       = data.aws_cloudformation_type.this.logging_config
}

output "provisioning_type" {
  description = "Provisioning behavior of the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.provisioning_type
}

output "schema" {
  description = "JSON document of the CloudFormation Type schema."
  value       = data.aws_cloudformation_type.this.schema
}

output "source_url" {
  description = "URL of the source code for the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.source_url
}

output "visibility" {
  description = "Scope of the CloudFormation Type."
  value       = data.aws_cloudformation_type.this.visibility
}