output "model_summaries" {
  description = "Model summaries"
  value       = data.aws_bedrock_custom_models.this.model_summaries
}

output "creation_time" {
  description = "Creation time of the models"
  value       = [for model in data.aws_bedrock_custom_models.this.model_summaries : model.creation_time]
}

output "model_arn" {
  description = "The ARNs of the custom models"
  value       = [for model in data.aws_bedrock_custom_models.this.model_summaries : model.model_arn]
}

output "model_name" {
  description = "The names of the custom models"
  value       = [for model in data.aws_bedrock_custom_models.this.model_summaries : model.model_name]
}