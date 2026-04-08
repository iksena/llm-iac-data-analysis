output "core_network_id" {
  description = "ID of the core network that a policy will be attached to and made LIVE"
  value       = aws_networkmanager_core_network_policy_attachment.this.core_network_id
}

output "policy_document" {
  description = "Policy document for creating a core network"
  value       = aws_networkmanager_core_network_policy_attachment.this.policy_document
}

output "state" {
  description = "Current state of a core network"
  value       = aws_networkmanager_core_network_policy_attachment.this.state
}