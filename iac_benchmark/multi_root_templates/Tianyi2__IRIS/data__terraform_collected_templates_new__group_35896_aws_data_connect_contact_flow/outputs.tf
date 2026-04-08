output "arn" {
  description = "ARN of the Contact Flow"
  value       = data.aws_connect_contact_flow.this.arn
}

output "content" {
  description = "Logic of the Contact Flow"
  value       = data.aws_connect_contact_flow.this.content
}

output "description" {
  description = "Description of the Contact Flow"
  value       = data.aws_connect_contact_flow.this.description
}

output "tags" {
  description = "Tags to assign to the Contact Flow"
  value       = data.aws_connect_contact_flow.this.tags
}

output "type" {
  description = "Type of Contact Flow"
  value       = data.aws_connect_contact_flow.this.type
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_connect_contact_flow.this.region
}

output "contact_flow_id" {
  description = "Contact Flow ID"
  value       = data.aws_connect_contact_flow.this.contact_flow_id
}

output "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  value       = data.aws_connect_contact_flow.this.instance_id
}

output "name" {
  description = "Name of the Contact Flow"
  value       = data.aws_connect_contact_flow.this.name
}