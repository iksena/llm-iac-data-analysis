output "arn" {
  description = "ARN of the Resiliency Policy."
  value       = aws_resiliencehub_resiliency_policy.this.arn
}

output "estimated_cost_tier" {
  description = "Estimated Cost Tier of the Resiliency Policy."
  value       = aws_resiliencehub_resiliency_policy.this.estimated_cost_tier
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_resiliencehub_resiliency_policy.this.tags_all
}