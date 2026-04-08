output "id" {
  description = "Set to the ARN of the found state machine, suitable for referencing in other resources that support State Machines"
  value       = data.aws_sfn_state_machine.this.id
}

output "arn" {
  description = "Set to the arn of the state function"
  value       = data.aws_sfn_state_machine.this.arn
}

output "role_arn" {
  description = "Set to the role_arn used by the state function"
  value       = data.aws_sfn_state_machine.this.role_arn
}

output "definition" {
  description = "Set to the state machine definition"
  value       = data.aws_sfn_state_machine.this.definition
}

output "creation_date" {
  description = "Date the state machine was created"
  value       = data.aws_sfn_state_machine.this.creation_date
}

output "revision_id" {
  description = "The revision identifier for the state machine"
  value       = data.aws_sfn_state_machine.this.revision_id
}

output "status" {
  description = "Set to the current status of the state machine"
  value       = data.aws_sfn_state_machine.this.status
}