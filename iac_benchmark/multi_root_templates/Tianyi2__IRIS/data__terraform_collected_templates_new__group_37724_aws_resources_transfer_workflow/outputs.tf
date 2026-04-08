output "arn" {
  description = "The Workflow ARN."
  value       = aws_transfer_workflow.this.arn
}

output "id" {
  description = "The Workflow id."
  value       = aws_transfer_workflow.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_transfer_workflow.this.tags_all
}