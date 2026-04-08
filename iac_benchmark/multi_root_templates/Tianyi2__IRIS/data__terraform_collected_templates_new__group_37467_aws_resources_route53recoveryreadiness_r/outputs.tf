output "arn" {
  description = "ARN of the readiness_check"
  value       = aws_route53recoveryreadiness_readiness_check.this.arn
}

output "readiness_check_name" {
  description = "Unique name describing the readiness check"
  value       = aws_route53recoveryreadiness_readiness_check.this.readiness_check_name
}

output "resource_set_name" {
  description = "Name describing the resource set that will be monitored for readiness"
  value       = aws_route53recoveryreadiness_readiness_check.this.resource_set_name
}

output "tags" {
  description = "Key-value mapping of resource tags"
  value       = aws_route53recoveryreadiness_readiness_check.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53recoveryreadiness_readiness_check.this.tags_all
}