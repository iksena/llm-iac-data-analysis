output "arn" {
  description = "ARN of the recovery group"
  value       = aws_route53recoveryreadiness_recovery_group.this.arn
}

output "recovery_group_name" {
  description = "A unique name describing the recovery group"
  value       = aws_route53recoveryreadiness_recovery_group.this.recovery_group_name
}

output "cells" {
  description = "List of cell arns to add as nested fault domains within this recovery group"
  value       = aws_route53recoveryreadiness_recovery_group.this.cells
}

output "tags" {
  description = "Key-value mapping of resource tags"
  value       = aws_route53recoveryreadiness_recovery_group.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53recoveryreadiness_recovery_group.this.tags_all
}