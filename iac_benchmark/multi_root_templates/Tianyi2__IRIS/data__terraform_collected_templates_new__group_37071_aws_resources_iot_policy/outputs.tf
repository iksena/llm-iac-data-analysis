output "arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = aws_iot_policy.this.arn
}

output "name" {
  description = "The name of this policy."
  value       = aws_iot_policy.this.name
}

output "default_version_id" {
  description = "The default version of this policy."
  value       = aws_iot_policy.this.default_version_id
}

output "policy" {
  description = "The policy document."
  value       = aws_iot_policy.this.policy
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iot_policy.this.tags_all
}