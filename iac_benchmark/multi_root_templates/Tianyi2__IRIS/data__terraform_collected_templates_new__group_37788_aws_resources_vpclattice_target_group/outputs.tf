output "arn" {
  description = "ARN of the target group."
  value       = aws_vpclattice_target_group.this.arn
}

output "id" {
  description = "Unique identifier for the target group."
  value       = aws_vpclattice_target_group.this.id
}

output "status" {
  description = "Status of the target group."
  value       = aws_vpclattice_target_group.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpclattice_target_group.this.tags_all
}