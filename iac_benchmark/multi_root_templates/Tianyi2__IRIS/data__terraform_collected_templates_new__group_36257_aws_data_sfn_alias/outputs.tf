output "arn" {
  description = "ARN identifying the State Machine alias"
  value       = data.aws_sfn_alias.this.arn
}

output "creation_date" {
  description = "Date the state machine Alias was created"
  value       = data.aws_sfn_alias.this.creation_date
}

output "description" {
  description = "Description of state machine alias"
  value       = data.aws_sfn_alias.this.description
}

output "routing_configuration" {
  description = "Routing Configuration of state machine alias"
  value       = data.aws_sfn_alias.this.routing_configuration
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_sfn_alias.this.region
}

output "name" {
  description = "Name of the State Machine alias"
  value       = data.aws_sfn_alias.this.name
}

output "statemachine_arn" {
  description = "ARN of the State Machine"
  value       = data.aws_sfn_alias.this.statemachine_arn
}