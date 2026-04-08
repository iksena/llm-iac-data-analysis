output "arn" {
  description = "The Amazon Resource Name of the scheduling policy."
  value       = aws_batch_scheduling_policy.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_batch_scheduling_policy.this.tags_all
}

output "name" {
  description = "The name of the scheduling policy."
  value       = aws_batch_scheduling_policy.this.name
}

output "fair_share_policy" {
  description = "The fairshare policy configuration."
  value       = aws_batch_scheduling_policy.this.fair_share_policy
}

output "tags" {
  description = "The tags assigned to the resource."
  value       = aws_batch_scheduling_policy.this.tags
}