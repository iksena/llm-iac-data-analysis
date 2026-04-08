output "global_network_id" {
  description = "ID of the specific global network"
  value       = data.aws_networkmanager_global_network.this.global_network_id
}

output "arn" {
  description = "ARN of the global network"
  value       = data.aws_networkmanager_global_network.this.arn
}

output "description" {
  description = "Description of the global network"
  value       = data.aws_networkmanager_global_network.this.description
}

output "tags" {
  description = "Map of resource tags"
  value       = data.aws_networkmanager_global_network.this.tags
}