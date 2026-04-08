output "id" {
  description = "A comma-delimited string combining group_arn and resource_arn."
  value       = aws_resourcegroups_resource.this.id
}

output "resource_type" {
  description = "The resource type of a resource, such as AWS::EC2::Instance."
  value       = aws_resourcegroups_resource.this.resource_type
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_resourcegroups_resource.this.region
}

output "group_arn" {
  description = "Name or ARN of the resource group to add resources to."
  value       = aws_resourcegroups_resource.this.group_arn
}

output "resource_arn" {
  description = "ARN of the resource to be added to the group."
  value       = aws_resourcegroups_resource.this.resource_arn
}