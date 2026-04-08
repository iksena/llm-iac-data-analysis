output "id" {
  description = "The name of the domain."
  value       = aws_swf_domain.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN)"
  value       = aws_swf_domain.this.arn
}

output "name" {
  description = "The name of the domain."
  value       = aws_swf_domain.this.name
}

output "name_prefix" {
  description = "The name prefix of the domain."
  value       = aws_swf_domain.this.name_prefix
}

output "description" {
  description = "The domain description."
  value       = aws_swf_domain.this.description
}

output "workflow_execution_retention_period_in_days" {
  description = "Length of time that SWF will continue to retain information about the workflow execution after the workflow execution is complete."
  value       = aws_swf_domain.this.workflow_execution_retention_period_in_days
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_swf_domain.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_swf_domain.this.tags_all
}