output "arn" {
  description = "Amazon Resource Name (ARN) of the Trust Anchor"
  value       = aws_rolesanywhere_trust_anchor.this.arn
}

output "id" {
  description = "The Trust Anchor ID"
  value       = aws_rolesanywhere_trust_anchor.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rolesanywhere_trust_anchor.this.tags_all
}