output "inference_profile_arn" {
  description = "The Amazon Resource Name (ARN) of the inference profile."
  value       = data.aws_bedrock_inference_profile.this.inference_profile_arn
}

output "inference_profile_name" {
  description = "The unique identifier of the inference profile."
  value       = data.aws_bedrock_inference_profile.this.inference_profile_name
}

output "models" {
  description = "A list of information about each model in the inference profile."
  value       = data.aws_bedrock_inference_profile.this.models
}

output "status" {
  description = "The status of the inference profile. ACTIVE means that the inference profile is available to use."
  value       = data.aws_bedrock_inference_profile.this.status
}

output "type" {
  description = "The type of the inference profile. SYSTEM_DEFINED means that the inference profile is defined by Amazon Bedrock. APPLICATION means that the inference profile is defined by the user."
  value       = data.aws_bedrock_inference_profile.this.type
}

output "created_at" {
  description = "The time at which the inference profile was created."
  value       = data.aws_bedrock_inference_profile.this.created_at
}

output "description" {
  description = "The description of the inference profile."
  value       = data.aws_bedrock_inference_profile.this.description
}

output "updated_at" {
  description = "The time at which the inference profile was last updated."
  value       = data.aws_bedrock_inference_profile.this.updated_at
}