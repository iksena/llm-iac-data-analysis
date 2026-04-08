output "id" {
  description = "Unique identifier for the control."
  value       = data.aws_auditmanager_control.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the control."
  value       = data.aws_auditmanager_control.this.arn
}

output "name" {
  description = "Name of the control."
  value       = data.aws_auditmanager_control.this.name
}

output "type" {
  description = "Type of control."
  value       = data.aws_auditmanager_control.this.type
}

output "description" {
  description = "Description of the control."
  value       = data.aws_auditmanager_control.this.description
}

output "testing_information" {
  description = "Testing information for the control."
  value       = data.aws_auditmanager_control.this.testing_information
}

output "action_plan_title" {
  description = "Title of the action plan for the control."
  value       = data.aws_auditmanager_control.this.action_plan_title
}

output "action_plan_instructions" {
  description = "Action plan instructions for the control."
  value       = data.aws_auditmanager_control.this.action_plan_instructions
}


output "control_mapping_sources" {
  description = "Control mapping sources configuration."
  value       = data.aws_auditmanager_control.this.control_mapping_sources
}

output "tags" {
  description = "Map of tags assigned to the control."
  value       = data.aws_auditmanager_control.this.tags
}

