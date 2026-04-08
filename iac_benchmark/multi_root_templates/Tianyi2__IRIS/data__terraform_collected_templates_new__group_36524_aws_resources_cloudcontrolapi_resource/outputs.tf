output "desired_state" {
  description = "JSON string matching the CloudFormation resource type schema with desired configuration."
  value       = aws_cloudcontrolapi_resource.this.desired_state
}

output "type_name" {
  description = "CloudFormation resource type name."
  value       = aws_cloudcontrolapi_resource.this.type_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_cloudcontrolapi_resource.this.region
}

output "role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM Role assumed for operations."
  value       = aws_cloudcontrolapi_resource.this.role_arn
}

output "schema" {
  description = "JSON string of the CloudFormation resource type schema."
  value       = aws_cloudcontrolapi_resource.this.schema
  sensitive   = true
}

output "type_version_id" {
  description = "Identifier of the CloudFormation resource type version."
  value       = aws_cloudcontrolapi_resource.this.type_version_id
}

output "properties" {
  description = "JSON string matching the CloudFormation resource type schema with current configuration."
  value       = aws_cloudcontrolapi_resource.this.properties
}