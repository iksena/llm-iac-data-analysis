output "protection_group_arn" {
  description = "The ARN (Amazon Resource Name) of the protection group"
  value       = aws_shield_protection_group.this.protection_group_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_shield_protection_group.this.tags_all
}