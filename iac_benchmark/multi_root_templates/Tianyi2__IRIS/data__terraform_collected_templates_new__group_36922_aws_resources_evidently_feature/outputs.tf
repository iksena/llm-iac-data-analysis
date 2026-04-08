output "arn" {
  description = "The ARN of the feature"
  value       = aws_evidently_feature.this.arn
}

output "created_time" {
  description = "The date and time that the feature is created"
  value       = aws_evidently_feature.this.created_time
}

output "evaluation_rules" {
  description = "One or more blocks that define the evaluation rules for the feature"
  value       = aws_evidently_feature.this.evaluation_rules
}

output "id" {
  description = "The feature name and the project name or arn separated by a colon (:)"
  value       = aws_evidently_feature.this.id
}

output "last_updated_time" {
  description = "The date and time that the feature was most recently updated"
  value       = aws_evidently_feature.this.last_updated_time
}

output "status" {
  description = "The current state of the feature. Valid values are AVAILABLE and UPDATING"
  value       = aws_evidently_feature.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_evidently_feature.this.tags_all
}

output "value_type" {
  description = "Defines the type of value used to define the different feature variations. Valid Values: STRING, LONG, DOUBLE, BOOLEAN"
  value       = aws_evidently_feature.this.value_type
}