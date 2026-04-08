output "identifier" {
  description = "Identifier of the CloudFormation resource type"
  value       = data.aws_cloudcontrolapi_resource.this.identifier
}

output "type_name" {
  description = "CloudFormation resource type name"
  value       = data.aws_cloudcontrolapi_resource.this.type_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_cloudcontrolapi_resource.this.region
}

output "role_arn" {
  description = "ARN of the IAM Role assumed for operations"
  value       = data.aws_cloudcontrolapi_resource.this.role_arn
}

output "type_version_id" {
  description = "Identifier of the CloudFormation resource type version"
  value       = data.aws_cloudcontrolapi_resource.this.type_version_id
}

output "properties" {
  description = "JSON string matching the CloudFormation resource type schema with current configuration"
  value       = data.aws_cloudcontrolapi_resource.this.properties
}