output "arn" {
  description = "Amazon Resource Name (ARN) of the StackSet."
  value       = aws_cloudformation_stack_set.this.arn
}

output "id" {
  description = "Name of the StackSet."
  value       = aws_cloudformation_stack_set.this.id
}

output "stack_set_id" {
  description = "Unique identifier of the StackSet."
  value       = aws_cloudformation_stack_set.this.stack_set_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudformation_stack_set.this.tags_all
}