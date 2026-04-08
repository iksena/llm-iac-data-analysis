output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall."
  value       = aws_networkfirewall_firewall.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall."
  value       = aws_networkfirewall_firewall.this.arn
}

output "firewall_status" {
  description = "Nested list of information about the current status of the firewall."
  value       = aws_networkfirewall_firewall.this.firewall_status
}

output "firewall_status_sync_states" {
  description = "Set of subnets configured for use by the firewall."
  value       = try(aws_networkfirewall_firewall.this.firewall_status[0].sync_states, [])
}

output "firewall_status_sync_states_attachment" {
  description = "Nested list describing the attachment status of the firewall's association with VPC subnets."
  value       = try([for state in aws_networkfirewall_firewall.this.firewall_status[0].sync_states : state.attachment], [])
}

output "firewall_status_sync_states_attachment_endpoint_ids" {
  description = "List of identifiers of the firewall endpoints that AWS Network Firewall has instantiated in the subnets."
  value       = try(flatten([for state in aws_networkfirewall_firewall.this.firewall_status[0].sync_states : [for attachment in state.attachment : attachment.endpoint_id]]), [])
}

output "firewall_status_sync_states_attachment_subnet_ids" {
  description = "List of unique identifiers of the subnets that have been specified to be used for firewall endpoints."
  value       = try(flatten([for state in aws_networkfirewall_firewall.this.firewall_status[0].sync_states : [for attachment in state.attachment : attachment.subnet_id]]), [])
}

output "firewall_status_sync_states_availability_zones" {
  description = "List of Availability Zones where the subnets are configured."
  value       = try([for state in aws_networkfirewall_firewall.this.firewall_status[0].sync_states : state.availability_zone], [])
}

output "firewall_status_transit_gateway_attachment_sync_states" {
  description = "Set of transit gateway configured for use by the firewall."
  value       = try(aws_networkfirewall_firewall.this.firewall_status[0].transit_gateway_attachment_sync_states, [])
}

output "firewall_status_transit_gateway_attachment_sync_states_attachment_ids" {
  description = "List of unique identifiers of the transit gateway attachments."
  value       = try([for state in aws_networkfirewall_firewall.this.firewall_status[0].transit_gateway_attachment_sync_states : state.attachment_id], [])
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_networkfirewall_firewall.this.tags_all
}

output "transit_gateway_owner_account_id" {
  description = "The AWS account ID that owns the transit gateway."
  value       = aws_networkfirewall_firewall.this.transit_gateway_owner_account_id
}

output "update_token" {
  description = "A string token used when updating a firewall."
  value       = aws_networkfirewall_firewall.this.update_token
}