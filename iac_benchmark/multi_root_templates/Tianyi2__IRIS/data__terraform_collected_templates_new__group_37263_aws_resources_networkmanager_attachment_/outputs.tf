output "attachment_id" {
  description = "ID of the attachment."
  value       = aws_networkmanager_attachment_accepter.this.attachment_id
}

output "attachment_type" {
  description = "Type of attachment."
  value       = aws_networkmanager_attachment_accepter.this.attachment_type
}

output "attachment_policy_rule_number" {
  description = "Policy rule number associated with the attachment."
  value       = aws_networkmanager_attachment_accepter.this.attachment_policy_rule_number
}

output "core_network_arn" {
  description = "ARN of the core network."
  value       = aws_networkmanager_attachment_accepter.this.core_network_arn
}

output "core_network_id" {
  description = "ID of the core network."
  value       = aws_networkmanager_attachment_accepter.this.core_network_id
}

output "edge_location" {
  description = "Region where the edge is located. This is returned for all attachment types except Direct Connect gateway attachments, which instead return edge_locations."
  value       = aws_networkmanager_attachment_accepter.this.edge_location
}

output "edge_locations" {
  description = "Edge locations that the Direct Connect gateway is associated with. This is returned only for Direct Connect gateway attachments. All other attachment types return edge_location."
  value       = aws_networkmanager_attachment_accepter.this.edge_locations
}

output "owner_account_id" {
  description = "ID of the attachment account owner."
  value       = aws_networkmanager_attachment_accepter.this.owner_account_id
}

output "resource_arn" {
  description = "Attachment resource ARN."
  value       = aws_networkmanager_attachment_accepter.this.resource_arn
}

output "segment_name" {
  description = "Name of the segment attachment."
  value       = aws_networkmanager_attachment_accepter.this.segment_name
}

output "state" {
  description = "State of the attachment."
  value       = aws_networkmanager_attachment_accepter.this.state
}