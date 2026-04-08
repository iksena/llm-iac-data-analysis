output "arn" {
  description = "ARN of the attachment"
  value       = aws_networkmanager_dx_gateway_attachment.this.arn
}

output "attachment_policy_rule_number" {
  description = "Policy rule number associated with the attachment"
  value       = aws_networkmanager_dx_gateway_attachment.this.attachment_policy_rule_number
}

output "attachment_type" {
  description = "Type of attachment"
  value       = aws_networkmanager_dx_gateway_attachment.this.attachment_type
}

output "core_network_arn" {
  description = "ARN of the core network for the attachment"
  value       = aws_networkmanager_dx_gateway_attachment.this.core_network_arn
}

output "id" {
  description = "ID of the attachment"
  value       = aws_networkmanager_dx_gateway_attachment.this.id
}

output "owner_account_id" {
  description = "ID of the attachment account owner"
  value       = aws_networkmanager_dx_gateway_attachment.this.owner_account_id
}

output "segment_name" {
  description = "Name of the segment attachment"
  value       = aws_networkmanager_dx_gateway_attachment.this.segment_name
}

output "state" {
  description = "State of the attachment"
  value       = aws_networkmanager_dx_gateway_attachment.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_dx_gateway_attachment.this.tags_all
}