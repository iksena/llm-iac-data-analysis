output "id" {
  description = "A unique identifier of the stack."
  value       = aws_cloudformation_stack.this.id
}

output "outputs" {
  description = "A map of outputs from the stack."
  value       = aws_cloudformation_stack.this.outputs
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudformation_stack.this.tags_all
}