output "arn" {
  description = "ARN of the collaboration."
  value       = aws_cleanrooms_collaboration.this.arn
}

output "id" {
  description = "ID of the collaboration."
  value       = aws_cleanrooms_collaboration.this.id
}

output "create_time" {
  description = "Date and time the collaboration was created."
  value       = aws_cleanrooms_collaboration.this.create_time
}


output "updated_time" {
  description = "Date and time the collaboration was last updated."
  value       = aws_cleanrooms_collaboration.this.update_time
}