output "arn" {
  description = "ARN of the Security Profile"
  value       = data.aws_connect_security_profile.this.arn
}

output "description" {
  description = "Description of the Security Profile"
  value       = data.aws_connect_security_profile.this.description
}

output "id" {
  description = "Identifier of the hosting Amazon Connect Instance and identifier of the Security Profile separated by a colon (:)"
  value       = data.aws_connect_security_profile.this.id
}

output "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  value       = data.aws_connect_security_profile.this.instance_id
}

output "name" {
  description = "Name of the Security Profile"
  value       = data.aws_connect_security_profile.this.name
}

output "organization_resource_id" {
  description = "The organization resource identifier for the security profile"
  value       = data.aws_connect_security_profile.this.organization_resource_id
}

output "permissions" {
  description = "List of permissions assigned to the security profile"
  value       = data.aws_connect_security_profile.this.permissions
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_connect_security_profile.this.region
}

output "security_profile_id" {
  description = "Security Profile identifier"
  value       = data.aws_connect_security_profile.this.security_profile_id
}

output "tags" {
  description = "Map of tags to assign to the Security Profile"
  value       = data.aws_connect_security_profile.this.tags
}