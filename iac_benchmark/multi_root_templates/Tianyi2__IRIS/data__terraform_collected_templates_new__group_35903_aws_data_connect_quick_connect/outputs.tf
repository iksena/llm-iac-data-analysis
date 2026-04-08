output "arn" {
  description = "ARN of the Quick Connect"
  value       = data.aws_connect_quick_connect.this.arn
}

output "description" {
  description = "Description of the Quick Connect"
  value       = data.aws_connect_quick_connect.this.description
}

output "id" {
  description = "Identifier of the hosting Amazon Connect Instance and identifier of the Quick Connect separated by a colon (:)"
  value       = data.aws_connect_quick_connect.this.id
}

output "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  value       = data.aws_connect_quick_connect.this.instance_id
}

output "name" {
  description = "Name of the Quick Connect"
  value       = data.aws_connect_quick_connect.this.name
}

output "quick_connect_config" {
  description = "A block that defines the configuration information for the Quick Connect"
  value       = data.aws_connect_quick_connect.this.quick_connect_config
}

output "quick_connect_id" {
  description = "Identifier for the Quick Connect"
  value       = data.aws_connect_quick_connect.this.quick_connect_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_connect_quick_connect.this.region
}

output "tags" {
  description = "Map of tags assigned to the Quick Connect"
  value       = data.aws_connect_quick_connect.this.tags
}