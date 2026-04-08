output "active_experiment_count" {
  description = "The number of ongoing experiments currently in the project."
  value       = aws_evidently_project.this.active_experiment_count
}

output "active_launch_count" {
  description = "The number of ongoing launches currently in the project."
  value       = aws_evidently_project.this.active_launch_count
}

output "arn" {
  description = "The ARN of the project."
  value       = aws_evidently_project.this.arn
}

output "created_time" {
  description = "The date and time that the project is created."
  value       = aws_evidently_project.this.created_time
}

output "experiment_count" {
  description = "The number of experiments currently in the project."
  value       = aws_evidently_project.this.experiment_count
}

output "feature_count" {
  description = "The number of features currently in the project."
  value       = aws_evidently_project.this.feature_count
}

output "id" {
  description = "The ID has the same value as the arn of the project."
  value       = aws_evidently_project.this.id
}

output "last_updated_time" {
  description = "The date and time that the project was most recently updated."
  value       = aws_evidently_project.this.last_updated_time
}

output "launch_count" {
  description = "The number of launches currently in the project."
  value       = aws_evidently_project.this.launch_count
}

output "status" {
  description = "The current state of the project. Valid values are AVAILABLE and UPDATING."
  value       = aws_evidently_project.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_evidently_project.this.tags_all
}