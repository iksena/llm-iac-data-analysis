output "customizations_supported" {
  description = "Customizations that the model supports."
  value       = data.aws_bedrock_foundation_model.this.customizations_supported
}

output "inference_types_supported" {
  description = "Inference types that the model supports."
  value       = data.aws_bedrock_foundation_model.this.inference_types_supported
}

output "input_modalities" {
  description = "Input modalities that the model supports."
  value       = data.aws_bedrock_foundation_model.this.input_modalities
}

output "model_arn" {
  description = "Model ARN."
  value       = data.aws_bedrock_foundation_model.this.model_arn
}

output "model_id" {
  description = "Model identifier."
  value       = data.aws_bedrock_foundation_model.this.model_id
}

output "model_name" {
  description = "Model name."
  value       = data.aws_bedrock_foundation_model.this.model_name
}

output "output_modalities" {
  description = "Output modalities that the model supports."
  value       = data.aws_bedrock_foundation_model.this.output_modalities
}

output "provider_name" {
  description = "Model provider name."
  value       = data.aws_bedrock_foundation_model.this.provider_name
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_bedrock_foundation_model.this.region
}

output "response_streaming_supported" {
  description = "Indicates whether the model supports streaming."
  value       = data.aws_bedrock_foundation_model.this.response_streaming_supported
}