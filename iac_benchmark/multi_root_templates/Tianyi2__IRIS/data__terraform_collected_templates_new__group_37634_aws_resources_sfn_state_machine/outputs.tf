output "id" {
  description = "The ARN of the state machine."
  value       = aws_sfn_state_machine.this.id
}

output "arn" {
  description = "The ARN of the state machine."
  value       = aws_sfn_state_machine.this.arn
}

output "creation_date" {
  description = "The date the state machine was created."
  value       = aws_sfn_state_machine.this.creation_date
}

output "state_machine_version_arn" {
  description = "The ARN of the state machine version."
  value       = aws_sfn_state_machine.this.state_machine_version_arn
}

output "status" {
  description = "The current status of the state machine. Either ACTIVE or DELETING."
  value       = aws_sfn_state_machine.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sfn_state_machine.this.tags_all
}