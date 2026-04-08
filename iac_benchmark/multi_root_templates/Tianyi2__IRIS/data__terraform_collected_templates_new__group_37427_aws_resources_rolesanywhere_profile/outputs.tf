output "arn" {
  description = "Amazon Resource Name (ARN) of the Profile."
  value       = aws_rolesanywhere_profile.this.arn
}

output "id" {
  description = "The Profile ID."
  value       = aws_rolesanywhere_profile.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_rolesanywhere_profile.this.tags_all
}