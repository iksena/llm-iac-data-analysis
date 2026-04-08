output "id" {
  description = "AWS region."
  value       = data.aws_bedrock_foundation_models.this.id
}

output "model_summaries" {
  description = "List of model summary objects."
  value       = data.aws_bedrock_foundation_models.this.model_summaries
}

output "model_summaries_customizations_supported" {
  description = "Customizations that the models support."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.customizations_supported]
}

output "model_summaries_inference_types_supported" {
  description = "Inference types that the models support."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.inference_types_supported]
}

output "model_summaries_input_modalities" {
  description = "Input modalities that the models support."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.input_modalities]
}

output "model_summaries_model_arn" {
  description = "Model ARNs."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.model_arn]
}

output "model_summaries_model_id" {
  description = "Model identifiers."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.model_id]
}

output "model_summaries_model_name" {
  description = "Model names."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.model_name]
}

output "model_summaries_output_modalities" {
  description = "Output modalities that the models support."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.output_modalities]
}

output "model_summaries_provider_name" {
  description = "Model provider names."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.provider_name]
}

output "model_summaries_response_streaming_supported" {
  description = "Indicates whether the models support streaming."
  value       = [for model in data.aws_bedrock_foundation_models.this.model_summaries : model.response_streaming_supported]
}