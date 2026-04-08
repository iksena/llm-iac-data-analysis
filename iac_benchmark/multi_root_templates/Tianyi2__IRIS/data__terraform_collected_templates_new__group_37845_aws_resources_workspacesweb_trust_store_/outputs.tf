output "trust_store_arn" {
  description = "ARN of the trust store associated with the portal"
  value       = aws_workspacesweb_trust_store_association.this.trust_store_arn
}

output "portal_arn" {
  description = "ARN of the portal associated with the trust store"
  value       = aws_workspacesweb_trust_store_association.this.portal_arn
}

output "region" {
  description = "Region where the trust store association is managed"
  value       = aws_workspacesweb_trust_store_association.this.region
}