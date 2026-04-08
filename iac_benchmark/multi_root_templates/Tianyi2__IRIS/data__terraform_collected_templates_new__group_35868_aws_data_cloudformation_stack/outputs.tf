output "capabilities" {
  description = "List of capabilities"
  value       = data.aws_cloudformation_stack.this.capabilities
}

output "description" {
  description = "Description of the stack"
  value       = data.aws_cloudformation_stack.this.description
}

output "disable_rollback" {
  description = "Whether the rollback of the stack is disabled when stack creation fails"
  value       = data.aws_cloudformation_stack.this.disable_rollback
}

output "notification_arns" {
  description = "List of SNS topic ARNs to publish stack related events"
  value       = data.aws_cloudformation_stack.this.notification_arns
}

output "outputs" {
  description = "Map of outputs from the stack"
  value       = data.aws_cloudformation_stack.this.outputs
}

output "parameters" {
  description = "Map of parameters that specify input parameters for the stack"
  value       = data.aws_cloudformation_stack.this.parameters
}

output "tags" {
  description = "Map of tags associated with this stack"
  value       = data.aws_cloudformation_stack.this.tags
}

output "template_body" {
  description = "Structure containing the template body"
  value       = data.aws_cloudformation_stack.this.template_body
}

output "iam_role_arn" {
  description = "ARN of the IAM role used to create the stack"
  value       = data.aws_cloudformation_stack.this.iam_role_arn
}

output "timeout_in_minutes" {
  description = "Amount of time that can pass before the stack status becomes CREATE_FAILED"
  value       = data.aws_cloudformation_stack.this.timeout_in_minutes
}