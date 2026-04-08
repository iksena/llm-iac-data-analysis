output "event_categories" {
  description = "List of the event categories."
  value       = data.aws_db_event_categories.this.event_categories
}

output "id" {
  description = "Region of the event categories."
  value       = data.aws_db_event_categories.this.id
}