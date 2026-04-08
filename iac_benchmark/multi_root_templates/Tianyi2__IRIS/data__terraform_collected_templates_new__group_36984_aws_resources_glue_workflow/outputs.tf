output "arn" {
  description = "Amazon Resource Name (ARN) of Glue Workflow"
  value       = aws_glue_workflow.this.arn
}

output "id" {
  description = "Workflow name"
  value       = aws_glue_workflow.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_glue_workflow.this.tags_all
}