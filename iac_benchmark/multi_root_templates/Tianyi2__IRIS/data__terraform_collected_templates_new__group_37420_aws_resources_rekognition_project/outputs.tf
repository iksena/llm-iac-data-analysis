output "arn" {
  description = "ARN of the Project"
  value       = aws_rekognition_project.this.arn
}

output "name" {
  description = "Name of the project"
  value       = aws_rekognition_project.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_rekognition_project.this.region
}

output "auto_update" {
  description = "Automatic retraining configuration"
  value       = aws_rekognition_project.this.auto_update
}

output "feature" {
  description = "Feature being customized"
  value       = aws_rekognition_project.this.feature
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = aws_rekognition_project.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rekognition_project.this.tags_all
}