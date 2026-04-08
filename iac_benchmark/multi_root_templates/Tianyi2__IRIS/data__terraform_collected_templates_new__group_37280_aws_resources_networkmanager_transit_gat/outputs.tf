output "arn" {
  description = "Attachment ARN"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.arn
}

output "attachment_policy_rule_number" {
  description = "Policy rule number associated with the attachment"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.attachment_policy_rule_number
}

output "attachment_type" {
  description = "Type of attachment"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.attachment_type
}

output "core_network_arn" {
  description = "ARN of the core network"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.core_network_arn
}

output "core_network_id" {
  description = "ID of the core network"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.core_network_id
}

output "edge_location" {
  description = "Edge location for the peer"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.edge_location
}

output "id" {
  description = "ID of the attachment"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.id
}

output "owner_account_id" {
  description = "ID of the attachment account owner"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.owner_account_id
}

output "resource_arn" {
  description = "Attachment resource ARN"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.resource_arn
}

output "segment_name" {
  description = "Name of the segment attachment"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.segment_name
}

output "state" {
  description = "State of the attachment"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_transit_gateway_route_table_attachment.this.tags_all
}