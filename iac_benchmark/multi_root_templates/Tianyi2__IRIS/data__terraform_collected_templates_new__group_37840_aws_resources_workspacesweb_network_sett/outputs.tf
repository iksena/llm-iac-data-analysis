
output "network_settings_arn" {
  description = "ARN of the network settings associated with the portal."
  value       = aws_workspacesweb_network_settings_association.this.network_settings_arn
}

output "portal_arn" {
  description = "ARN of the portal associated with the network settings."
  value       = aws_workspacesweb_network_settings_association.this.portal_arn
}

output "region" {
  description = "Region where the resource is managed."
  value       = aws_workspacesweb_network_settings_association.this.region
}