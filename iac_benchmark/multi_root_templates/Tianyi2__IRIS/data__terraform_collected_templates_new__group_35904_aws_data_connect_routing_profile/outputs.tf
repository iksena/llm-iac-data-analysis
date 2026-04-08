output "arn" {
  description = "ARN of the Routing Profile"
  value       = data.aws_connect_routing_profile.this.arn
}

output "default_outbound_queue_id" {
  description = "Specifies the default outbound queue for the Routing Profile"
  value       = data.aws_connect_routing_profile.this.default_outbound_queue_id
}

output "description" {
  description = "Description of the Routing Profile"
  value       = data.aws_connect_routing_profile.this.description
}

output "id" {
  description = "Identifier of the hosting Amazon Connect Instance and identifier of the Routing Profile separated by a colon (:)"
  value       = data.aws_connect_routing_profile.this.id
}

output "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  value       = data.aws_connect_routing_profile.this.instance_id
}

output "media_concurrencies" {
  description = "One or more media_concurrencies blocks that specify the channels that agents can handle in the Contact Control Panel (CCP) for this Routing Profile"
  value       = data.aws_connect_routing_profile.this.media_concurrencies
}

output "name" {
  description = "Name of the Routing Profile"
  value       = data.aws_connect_routing_profile.this.name
}

output "queue_configs" {
  description = "One or more queue_configs blocks that specify the inbound queues associated with the routing profile"
  value       = data.aws_connect_routing_profile.this.queue_configs
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_connect_routing_profile.this.region
}

output "routing_profile_id" {
  description = "Identifier of the Routing Profile"
  value       = data.aws_connect_routing_profile.this.routing_profile_id
}

output "tags" {
  description = "Map of tags assigned to the Routing Profile"
  value       = data.aws_connect_routing_profile.this.tags
}