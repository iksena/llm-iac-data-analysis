output "base_model_arn" {
  description = "ARN of the base model."
  value       = data.aws_bedrock_custom_model.this.base_model_arn
}

output "creation_time" {
  description = "Creation time of the model."
  value       = data.aws_bedrock_custom_model.this.creation_time
}

output "hyperparameters" {
  description = "Hyperparameter values associated with this model."
  value       = data.aws_bedrock_custom_model.this.hyperparameters
}

output "job_arn" {
  description = "Job ARN associated with this model."
  value       = data.aws_bedrock_custom_model.this.job_arn
}

output "job_name" {
  description = "Job name associated with this model."
  value       = data.aws_bedrock_custom_model.this.job_name
}

output "job_tags" {
  description = "Key-value mapping of tags for the fine-tuning job."
  value       = data.aws_bedrock_custom_model.this.job_tags
}

output "model_arn" {
  description = "ARN associated with this model."
  value       = data.aws_bedrock_custom_model.this.model_arn
}

output "model_kms_key_arn" {
  description = "The custom model is encrypted at rest using this key."
  value       = data.aws_bedrock_custom_model.this.model_kms_key_arn
}

output "model_name" {
  description = "Model name associated with this model."
  value       = data.aws_bedrock_custom_model.this.model_name
}

output "model_tags" {
  description = "Key-value mapping of tags for the model."
  value       = data.aws_bedrock_custom_model.this.model_tags
}

output "output_data_config" {
  description = "Output data configuration associated with this custom model."
  value       = data.aws_bedrock_custom_model.this.output_data_config
}

output "training_data_config" {
  description = "Information about the training dataset."
  value       = data.aws_bedrock_custom_model.this.training_data_config
}

output "training_metrics" {
  description = "Metrics associated with the customization job."
  value       = data.aws_bedrock_custom_model.this.training_metrics
}

output "validation_data_config" {
  description = "Information about the validation dataset."
  value       = data.aws_bedrock_custom_model.this.validation_data_config
}

output "validation_metrics" {
  description = "The loss metric for each validator that you provided."
  value       = data.aws_bedrock_custom_model.this.validation_metrics
}