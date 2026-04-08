output "arn" {
  description = "ARN of the Voice Profile Domain."
  value       = aws_chimesdkvoice_voice_profile_domain.this.arn
}

output "id" {
  description = "ID of the Voice Profile Domain."
  value       = aws_chimesdkvoice_voice_profile_domain.this.id
}