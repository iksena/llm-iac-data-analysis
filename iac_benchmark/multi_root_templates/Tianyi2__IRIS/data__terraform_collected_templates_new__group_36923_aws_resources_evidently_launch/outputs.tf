output "arn" {
  description = "The ARN of the launch."
  value       = aws_evidently_launch.this.arn
}

output "created_time" {
  description = "The date and time that the launch is created."
  value       = aws_evidently_launch.this.created_time
}

output "execution" {
  description = "A block that contains information about the start and end times of the launch."
  value       = aws_evidently_launch.this.execution
}

output "id" {
  description = "The launch name and the project name or arn separated by a colon (:)."
  value       = aws_evidently_launch.this.id
}

output "last_updated_time" {
  description = "The date and time that the launch was most recently updated."
  value       = aws_evidently_launch.this.last_updated_time
}

output "status" {
  description = "The current state of the launch. Valid values are CREATED, UPDATING, RUNNING, COMPLETED, and CANCELLED."
  value       = aws_evidently_launch.this.status
}

output "status_reason" {
  description = "If the launch was stopped, this is the string that was entered by the person who stopped the launch, to explain why it was stopped."
  value       = aws_evidently_launch.this.status_reason
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_evidently_launch.this.tags_all
}

output "type" {
  description = "The type of launch."
  value       = aws_evidently_launch.this.type
}