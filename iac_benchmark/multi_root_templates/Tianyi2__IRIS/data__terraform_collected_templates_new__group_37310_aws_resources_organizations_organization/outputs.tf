output "accounts" {
  description = "List of child accounts for this Organizational Unit"
  value       = aws_organizations_organizational_unit.this.accounts
}

output "arn" {
  description = "ARN of the organizational unit"
  value       = aws_organizations_organizational_unit.this.arn
}

output "id" {
  description = "Identifier of the organization unit"
  value       = aws_organizations_organizational_unit.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_organizations_organizational_unit.this.tags_all
}