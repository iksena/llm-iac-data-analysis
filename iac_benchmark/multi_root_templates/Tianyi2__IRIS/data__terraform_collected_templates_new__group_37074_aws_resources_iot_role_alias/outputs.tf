output "arn" {
  description = "The ARN assigned by AWS to this role alias."
  value       = aws_iot_role_alias.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iot_role_alias.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_iot_role_alias.this.region
}

output "alias" {
  description = "The name of the role alias."
  value       = aws_iot_role_alias.this.alias
}

output "role_arn" {
  description = "The identity of the role to which the alias refers."
  value       = aws_iot_role_alias.this.role_arn
}

output "credential_duration" {
  description = "The duration of the credential, in seconds."
  value       = aws_iot_role_alias.this.credential_duration
}

output "tags" {
  description = "Key-value mapping of resource tags."
  value       = aws_iot_role_alias.this.tags
}