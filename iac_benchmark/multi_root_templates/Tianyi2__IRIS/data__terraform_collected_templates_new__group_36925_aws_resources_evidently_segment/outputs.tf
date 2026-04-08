output "arn" {
  description = "The ARN of the segment."
  value       = aws_evidently_segment.this.arn
}

output "created_time" {
  description = "The date and time that the segment is created."
  value       = aws_evidently_segment.this.created_time
}

output "experiment_count" {
  description = "The number of experiments that this segment is used in. This count includes all current experiments, not just those that are currently running."
  value       = aws_evidently_segment.this.experiment_count
}

output "id" {
  description = "The ID has the same value as the ARN of the segment."
  value       = aws_evidently_segment.this.id
}

output "last_updated_time" {
  description = "The date and time that this segment was most recently updated."
  value       = aws_evidently_segment.this.last_updated_time
}

output "launch_count" {
  description = "The number of launches that this segment is used in. This count includes all current launches, not just those that are currently running."
  value       = aws_evidently_segment.this.launch_count
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_evidently_segment.this.tags_all
}