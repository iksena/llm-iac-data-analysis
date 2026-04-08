output "configuration_id" {
  description = "System-generated unique identifier"
  value       = aws_codecommit_trigger.this.configuration_id
}

output "repository_name" {
  description = "The name of the repository"
  value       = aws_codecommit_trigger.this.repository_name
}

output "trigger" {
  description = "The trigger configuration"
  value       = aws_codecommit_trigger.this.trigger
}