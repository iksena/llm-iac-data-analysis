output "id" {
  description = "Identifier of the Detective Graph"
  value       = aws_detective_organization_configuration.this.id
}

output "auto_enable" {
  description = "When this setting is enabled, all new accounts that are created in, or added to, the organization are added as a member accounts of the organization's Detective delegated administrator and Detective is enabled in that AWS Region"
  value       = aws_detective_organization_configuration.this.auto_enable
}

output "graph_arn" {
  description = "ARN of the behavior graph"
  value       = aws_detective_organization_configuration.this.graph_arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_detective_organization_configuration.this.region
}