output "arn" {
  description = "Amazon Resource Name (ARN) of the event action."
  value       = aws_dataexchange_event_action.this.arn
}

output "created_at" {
  description = "Date and time when the resource was created."
  value       = aws_dataexchange_event_action.this.created_at
}

output "id" {
  description = "Unique identifier for the event action."
  value       = aws_dataexchange_event_action.this.id
}

output "updated_at" {
  description = "Date and time when the resource was last updated."
  value       = aws_dataexchange_event_action.this.updated_at
}