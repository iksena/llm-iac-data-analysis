output "stack_instance_summaries" {
  description = "List of stack instances created from an organizational unit deployment target."
  value       = aws_cloudformation_stack_instances.this.stack_instance_summaries
}

output "stack_set_id" {
  description = "Unique identifier of the stack set."
  value       = aws_cloudformation_stack_instances.this.stack_set_id
}

# Individual stack instance summary attributes for easier access
output "stack_instance_account_ids" {
  description = "List of account IDs where stack instances are deployed."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.account_id]
}

output "stack_instance_regions" {
  description = "List of regions where stack instances are deployed."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.region]
}

output "stack_instance_detailed_statuses" {
  description = "List of detailed statuses of the stack instances."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.detailed_status]
}

output "stack_instance_drift_statuses" {
  description = "List of drift statuses of the stack instances."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.drift_status]
}

output "stack_instance_organizational_unit_ids" {
  description = "List of organizational unit IDs for the stack instances."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.organizational_unit_id]
}

output "stack_instance_stack_ids" {
  description = "List of stack IDs of the stack instances."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.stack_id]
}

output "stack_instance_stack_set_ids" {
  description = "List of stack set IDs associated with the stack instances."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.stack_set_id]
}

output "stack_instance_statuses" {
  description = "List of statuses of the stack instances in terms of synchronization with the stack set."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.status]
}

output "stack_instance_status_reasons" {
  description = "List of status reasons for the stack instances."
  value       = [for instance in aws_cloudformation_stack_instances.this.stack_instance_summaries : instance.status_reason]
}