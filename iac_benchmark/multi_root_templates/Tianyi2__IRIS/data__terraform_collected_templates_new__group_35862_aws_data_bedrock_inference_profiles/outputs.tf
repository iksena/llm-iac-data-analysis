output "inference_profile_summaries" {
  description = "List of inference profile summary objects."
  value       = data.aws_bedrock_inference_profiles.this.inference_profile_summaries
}

output "created_at" {
  description = "Time at which the inference profile was created."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].created_at, null)
}

output "description" {
  description = "Description of the inference profile."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].description, null)
}

output "inference_profile_arn" {
  description = "Amazon Resource Name (ARN) of the inference profile."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].inference_profile_arn, null)
}

output "inference_profile_id" {
  description = "Unique identifier of the inference profile."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].inference_profile_id, null)
}

output "inference_profile_name" {
  description = "Name of the inference profile."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].inference_profile_name, null)
}

output "models" {
  description = "List of information about each model in the inference profile."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].models, null)
}

output "status" {
  description = "Status of the inference profile. ACTIVE means that the inference profile is available to use."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].status, null)
}

output "type" {
  description = "Type of the inference profile. SYSTEM_DEFINED means that the inference profile is defined by Amazon Bedrock. APPLICATION means the inference profile was created by a user."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].type, null)
}

output "updated_at" {
  description = "Time at which the inference profile was last updated."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].updated_at, null)
}

output "model_arn" {
  description = "Amazon Resource Name (ARN) of the model."
  value       = try(data.aws_bedrock_inference_profiles.this.inference_profile_summaries[*].models[*].model_arn, null)
}