output "arn" {
  description = "ARN of the attachment"
  value       = aws_networkmanager_vpc_attachment.this.arn
}

output "attachment_policy_rule_number" {
  description = "Policy rule number associated with the attachment"
  value       = aws_networkmanager_vpc_attachment.this.attachment_policy_rule_number
}

output "attachment_type" {
  description = "Type of attachment"
  value       = aws_networkmanager_vpc_attachment.this.attachment_type
}

output "core_network_arn" {
  description = "ARN of a core network"
  value       = aws_networkmanager_vpc_attachment.this.core_network_arn
}

output "core_network_id" {
  description = "ID of a core network for the VPC attachment"
  value       = aws_networkmanager_vpc_attachment.this.core_network_id
}

output "edge_location" {
  description = "Region where the edge is located"
  value       = aws_networkmanager_vpc_attachment.this.edge_location
}

output "id" {
  description = "ID of the attachment"
  value       = aws_networkmanager_vpc_attachment.this.id
}

output "owner_account_id" {
  description = "ID of the attachment account owner"
  value       = aws_networkmanager_vpc_attachment.this.owner_account_id
}

output "resource_arn" {
  description = "Attachment resource ARN"
  value       = aws_networkmanager_vpc_attachment.this.resource_arn
}

output "segment_name" {
  description = "Name of the segment attachment"
  value       = aws_networkmanager_vpc_attachment.this.segment_name
}

output "state" {
  description = "State of the attachment"
  value       = aws_networkmanager_vpc_attachment.this.state
}

output "subnet_arns" {
  description = "Subnet ARNs of the VPC attachment"
  value       = aws_networkmanager_vpc_attachment.this.subnet_arns
}

output "tags" {
  description = "Key-value tags for the attachment"
  value       = aws_networkmanager_vpc_attachment.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_vpc_attachment.this.tags_all
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_networkmanager_vpc_attachment.this.vpc_arn
}