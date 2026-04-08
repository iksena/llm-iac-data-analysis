output "id" {
  description = "The unique identifiers of the experience and index separated by a slash (/)."
  value       = aws_kendra_experience.this.id
}

output "arn" {
  description = "ARN of the Experience."
  value       = aws_kendra_experience.this.arn
}

output "endpoints" {
  description = "Shows the endpoint URLs for your Amazon Kendra experiences. The URLs are unique and fully hosted by AWS."
  value       = aws_kendra_experience.this.endpoints
}

output "experience_id" {
  description = "The unique identifier of the experience."
  value       = aws_kendra_experience.this.experience_id
}

output "status" {
  description = "The current processing status of your Amazon Kendra experience."
  value       = aws_kendra_experience.this.status
}