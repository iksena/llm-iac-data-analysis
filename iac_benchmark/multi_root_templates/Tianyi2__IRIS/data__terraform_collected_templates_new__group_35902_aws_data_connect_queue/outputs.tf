output "arn" {
  description = "ARN of the Queue"
  value       = data.aws_connect_queue.this.arn
}

output "description" {
  description = "Description of the Queue"
  value       = data.aws_connect_queue.this.description
}

output "hours_of_operation_id" {
  description = "Specifies the identifier of the Hours of Operation"
  value       = data.aws_connect_queue.this.hours_of_operation_id
}

output "id" {
  description = "Identifier of the hosting Amazon Connect Instance and identifier of the Queue separated by a colon (:)"
  value       = data.aws_connect_queue.this.id
}

output "max_contacts" {
  description = "Maximum number of contacts that can be in the queue before it is considered full. Minimum value of 0"
  value       = data.aws_connect_queue.this.max_contacts
}

output "outbound_caller_config" {
  description = "A block that defines the outbound caller ID name, number, and outbound whisper flow"
  value       = data.aws_connect_queue.this.outbound_caller_config
}

output "queue_id" {
  description = "Identifier for the Queue"
  value       = data.aws_connect_queue.this.queue_id
}

output "status" {
  description = "Description of the Queue. Values are ENABLED or DISABLED"
  value       = data.aws_connect_queue.this.status
}

output "tags" {
  description = "Map of tags assigned to the Queue"
  value       = data.aws_connect_queue.this.tags
}

output "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  value       = data.aws_connect_queue.this.instance_id
}

output "name" {
  description = "Name of the Queue"
  value       = data.aws_connect_queue.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_connect_queue.this.region
}