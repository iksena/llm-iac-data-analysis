output "id" {
  description = "The ID of the Input"
  value       = data.aws_medialive_input.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_medialive_input.this.region
}

output "arn" {
  description = "ARN of the Input"
  value       = data.aws_medialive_input.this.arn
}

output "attached_channels" {
  description = "Channels attached to Input"
  value       = data.aws_medialive_input.this.attached_channels
}

output "destinations" {
  description = "Destination settings for PUSH type inputs"
  value       = data.aws_medialive_input.this.destinations
}

output "input_class" {
  description = "The input class"
  value       = data.aws_medialive_input.this.input_class
}

output "input_devices" {
  description = "Settings for the devices"
  value       = data.aws_medialive_input.this.input_devices
}

output "input_partner_ids" {
  description = "A list of IDs for all Inputs which are partners of this one"
  value       = data.aws_medialive_input.this.input_partner_ids
}

output "input_source_type" {
  description = "Source type of the input"
  value       = data.aws_medialive_input.this.input_source_type
}

output "media_connect_flows" {
  description = "A list of the MediaConnect Flows"
  value       = data.aws_medialive_input.this.media_connect_flows
}

output "name" {
  description = "Name of the input"
  value       = data.aws_medialive_input.this.name
}

output "role_arn" {
  description = "The ARN of the role this input assumes during and after creation"
  value       = data.aws_medialive_input.this.role_arn
}

output "security_groups" {
  description = "List of input security groups"
  value       = data.aws_medialive_input.this.security_groups
}

output "sources" {
  description = "The source URLs for a PULL-type input"
  value       = data.aws_medialive_input.this.sources
}

output "state" {
  description = "The state of the input"
  value       = data.aws_medialive_input.this.state
}

output "tags" {
  description = "A map of tags assigned to the Input"
  value       = data.aws_medialive_input.this.tags
}

output "type" {
  description = "The type of the input"
  value       = data.aws_medialive_input.this.type
}