output "arn" {
  description = "The Amazon Resource Name (ARN) of the Security Profile."
  value       = aws_connect_security_profile.this.arn
}

output "organization_resource_id" {
  description = "The organization resource identifier for the security profile."
  value       = aws_connect_security_profile.this.organization_resource_id
}

output "security_profile_id" {
  description = "The identifier for the Security Profile."
  value       = aws_connect_security_profile.this.security_profile_id
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the Security Profile separated by a colon (:)."
  value       = aws_connect_security_profile.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_security_profile.this.tags_all
}