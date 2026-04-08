output "id" {
  description = "Type of AWS resource collection to create (same value as type)."
  value       = aws_devopsguru_resource_collection.this.id
}

output "type" {
  description = "Type of AWS resource collection."
  value       = aws_devopsguru_resource_collection.this.type
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_devopsguru_resource_collection.this.region
}

output "cloudformation" {
  description = "CloudFormation configuration."
  value       = aws_devopsguru_resource_collection.this.cloudformation
}

output "tags" {
  description = "Tags configuration."
  value       = aws_devopsguru_resource_collection.this.tags
}