output "id" {
  description = "Unique identifier for the resource"
  value       = aws_cloudformation_stack_set_instance.this.id
}

output "organizational_unit_id" {
  description = "Organization root ID or organizational unit (OU) ID in which the stack is deployed"
  value       = aws_cloudformation_stack_set_instance.this.organizational_unit_id
}

output "stack_id" {
  description = "Stack identifier"
  value       = aws_cloudformation_stack_set_instance.this.stack_id
}

output "stack_instance_summaries" {
  description = "List of stack instances created from an organizational unit deployment target"
  value       = aws_cloudformation_stack_set_instance.this.stack_instance_summaries
}