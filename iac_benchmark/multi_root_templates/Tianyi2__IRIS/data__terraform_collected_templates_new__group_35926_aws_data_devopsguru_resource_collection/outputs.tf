output "id" {
  description = "Type of AWS resource collection to create (same value as type)."
  value       = data.aws_devopsguru_resource_collection.this.id
}

output "cloudformation" {
  description = "A collection of AWS CloudFormation stacks."
  value       = data.aws_devopsguru_resource_collection.this.cloudformation
}

output "cloudformation_stack_names" {
  description = "Array of the names of the AWS CloudFormation stacks."
  value       = try(data.aws_devopsguru_resource_collection.this.cloudformation[*].stack_names, [])
}

output "tags" {
  description = "AWS tags used to filter the resources in the resource collection."
  value       = data.aws_devopsguru_resource_collection.this.tags
}

output "tags_app_boundary_key" {
  description = "An AWS tag key that is used to identify the AWS resources that DevOps Guru analyzes."
  value       = try(data.aws_devopsguru_resource_collection.this.tags[*].app_boundary_key, null)
}

output "tags_tag_values" {
  description = "Array of tag values."
  value       = try(data.aws_devopsguru_resource_collection.this.tags[*].tag_values, [])
}

output "region" {
  description = "Region where this resource is managed."
  value       = var.region
}

output "type" {
  description = "Type of AWS resource collection."
  value       = var.type
}