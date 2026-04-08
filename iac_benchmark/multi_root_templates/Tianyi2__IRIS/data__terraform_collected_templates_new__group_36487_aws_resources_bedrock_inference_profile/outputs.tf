output "arn" {
  description = "The Amazon Resource Name (ARN) of the inference profile"
  value       = aws_bedrock_inference_profile.this.arn
}

output "id" {
  description = "The unique identifier of the inference profile"
  value       = aws_bedrock_inference_profile.this.id
}

output "name" {
  description = "The unique identifier of the inference profile"
  value       = aws_bedrock_inference_profile.this.name
}

output "models" {
  description = "A list of information about each model in the inference profile"
  value       = aws_bedrock_inference_profile.this.models
}

output "status" {
  description = "The status of the inference profile"
  value       = aws_bedrock_inference_profile.this.status
}

output "type" {
  description = "The type of the inference profile"
  value       = aws_bedrock_inference_profile.this.type
}

output "created_at" {
  description = "The time at which the inference profile was created"
  value       = aws_bedrock_inference_profile.this.created_at
}

output "description" {
  description = "The description of the inference profile"
  value       = aws_bedrock_inference_profile.this.description
}

output "updated_at" {
  description = "The time at which the inference profile was last updated"
  value       = aws_bedrock_inference_profile.this.updated_at
}