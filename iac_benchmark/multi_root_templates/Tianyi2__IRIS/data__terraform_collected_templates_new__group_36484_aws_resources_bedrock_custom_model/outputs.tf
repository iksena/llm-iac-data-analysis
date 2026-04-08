output "custom_model_arn" {
  description = "The ARN of the output model."
  value       = aws_bedrock_custom_model.this.custom_model_arn
}

output "job_arn" {
  description = "The ARN of the customization job."
  value       = aws_bedrock_custom_model.this.job_arn
}

output "job_status" {
  description = "The status of the customization job. A successful job transitions from InProgress to Completed when the output model is ready to use."
  value       = aws_bedrock_custom_model.this.job_status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_bedrock_custom_model.this.tags_all
}

output "training_metrics" {
  description = "Metrics associated with the customization job."
  value       = aws_bedrock_custom_model.this.training_metrics
}

output "validation_metrics" {
  description = "The loss metric for each validator that you provided."
  value       = aws_bedrock_custom_model.this.validation_metrics
}