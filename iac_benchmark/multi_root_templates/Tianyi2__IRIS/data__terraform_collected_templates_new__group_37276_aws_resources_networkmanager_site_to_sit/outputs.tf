output "arn" {
  description = "ARN of the attachment"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.arn
}

output "attachment_policy_rule_number" {
  description = "Policy rule number associated with the attachment"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.attachment_policy_rule_number
}

output "attachment_type" {
  description = "Type of attachment"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.attachment_type
}

output "core_network_arn" {
  description = "ARN of a core network"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.core_network_arn
}

output "edge_location" {
  description = "Region where the edge is located"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.edge_location
}

output "id" {
  description = "ID of the attachment"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.id
}

output "owner_account_id" {
  description = "ID of the attachment account owner"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.owner_account_id
}

output "resource_arn" {
  description = "Attachment resource ARN"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.resource_arn
}

output "segment_name" {
  description = "Name of the segment attachment"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.segment_name
}

output "state" {
  description = "State of the attachment"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_site_to_site_vpn_attachment.this.tags_all
}