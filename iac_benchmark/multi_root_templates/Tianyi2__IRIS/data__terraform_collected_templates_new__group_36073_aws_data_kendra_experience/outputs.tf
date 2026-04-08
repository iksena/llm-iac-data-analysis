output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_kendra_experience.this.region
}

output "experience_id" {
  description = "Identifier of the Experience."
  value       = data.aws_kendra_experience.this.experience_id
}

output "index_id" {
  description = "Identifier of the index that contains the Experience."
  value       = data.aws_kendra_experience.this.index_id
}

output "arn" {
  description = "ARN of the Experience."
  value       = data.aws_kendra_experience.this.arn
}

output "configuration" {
  description = "Block that specifies the configuration information for your Amazon Kendra Experience."
  value       = data.aws_kendra_experience.this.configuration
}

output "created_at" {
  description = "Unix datetime that the Experience was created."
  value       = data.aws_kendra_experience.this.created_at
}

output "description" {
  description = "Description of the Experience."
  value       = data.aws_kendra_experience.this.description
}

output "endpoints" {
  description = "Shows the endpoint URLs for your Amazon Kendra Experiences."
  value       = data.aws_kendra_experience.this.endpoints
}

output "error_message" {
  description = "Reason your Amazon Kendra Experience could not properly process."
  value       = data.aws_kendra_experience.this.error_message
}

output "id" {
  description = "Unique identifiers of the Experience and index separated by a slash (/)."
  value       = data.aws_kendra_experience.this.id
}

output "name" {
  description = "Name of the Experience."
  value       = data.aws_kendra_experience.this.name
}

output "role_arn" {
  description = "Shows the ARN of a role with permission to access Query API, QuerySuggestions API, SubmitFeedback API, and AWS SSO."
  value       = data.aws_kendra_experience.this.role_arn
}

output "status" {
  description = "Current processing status of your Amazon Kendra Experience."
  value       = data.aws_kendra_experience.this.status
}

output "updated_at" {
  description = "Date and time that the Experience was last updated."
  value       = data.aws_kendra_experience.this.updated_at
}