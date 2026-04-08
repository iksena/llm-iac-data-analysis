output "arn" {
  description = "ARN of the connection."
  value       = data.aws_dx_connection.this.arn
}

output "aws_device" {
  description = "Direct Connect endpoint on which the physical connection terminates."
  value       = data.aws_dx_connection.this.aws_device
}

output "bandwidth" {
  description = "Bandwidth of the connection."
  value       = data.aws_dx_connection.this.bandwidth
}

output "id" {
  description = "ID of the connection."
  value       = data.aws_dx_connection.this.id
}

output "location" {
  description = "AWS Direct Connect location where the connection is located."
  value       = data.aws_dx_connection.this.location
}

output "owner_account_id" {
  description = "ID of the AWS account that owns the connection."
  value       = data.aws_dx_connection.this.owner_account_id
}

output "partner_name" {
  description = "The name of the AWS Direct Connect service provider associated with the connection."
  value       = data.aws_dx_connection.this.partner_name
}

output "provider_name" {
  description = "Name of the service provider associated with the connection."
  value       = data.aws_dx_connection.this.provider_name
}

output "state" {
  description = "State of the connection."
  value       = data.aws_dx_connection.this.state
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_dx_connection.this.tags
}

output "vlan_id" {
  description = "The VLAN ID."
  value       = data.aws_dx_connection.this.vlan_id
}