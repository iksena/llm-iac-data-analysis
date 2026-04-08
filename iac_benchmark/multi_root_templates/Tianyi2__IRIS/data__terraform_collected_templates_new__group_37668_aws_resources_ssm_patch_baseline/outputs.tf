output "arn" {
  description = "ARN of the baseline."
  value       = aws_ssm_patch_baseline.this.arn
}

output "id" {
  description = "ID of the baseline."
  value       = aws_ssm_patch_baseline.this.id
}

output "json" {
  description = "JSON definition of the baseline."
  value       = aws_ssm_patch_baseline.this.json
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssm_patch_baseline.this.tags_all
}