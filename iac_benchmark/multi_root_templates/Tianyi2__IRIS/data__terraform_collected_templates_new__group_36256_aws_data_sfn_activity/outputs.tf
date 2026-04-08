output "id" {
  description = "ARN that identifies the activity."
  value       = data.aws_sfn_activity.this.id
}

output "creation_date" {
  description = "Date the activity was created."
  value       = data.aws_sfn_activity.this.creation_date
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_sfn_activity.this.region
}

output "name" {
  description = "Name that identifies the activity."
  value       = data.aws_sfn_activity.this.name
}

output "arn" {
  description = "ARN that identifies the activity."
  value       = data.aws_sfn_activity.this.arn
}