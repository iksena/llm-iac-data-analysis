output "id" {
  description = "AWS Shield Proactive Engagement ID"
  value       = aws_shield_proactive_engagement.this.id
}

output "enabled" {
  description = "Whether Proactive Engagement is enabled"
  value       = aws_shield_proactive_engagement.this.enabled
}

output "emergency_contact" {
  description = "Emergency contacts configuration"
  value       = aws_shield_proactive_engagement.this.emergency_contact
}