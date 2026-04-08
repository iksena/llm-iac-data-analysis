output "fairshare_policy" {
  description = "Fairshare policy block specifies the compute_reservation, share_delay_seconds, and share_distribution of the scheduling policy"
  value       = data.aws_batch_scheduling_policy.this.fair_share_policy
}

output "name" {
  description = "Name of the scheduling policy"
  value       = data.aws_batch_scheduling_policy.this.name
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = data.aws_batch_scheduling_policy.this.tags
}

output "arn" {
  description = "ARN of the scheduling policy"
  value       = data.aws_batch_scheduling_policy.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_batch_scheduling_policy.this.region
}