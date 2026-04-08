output "arn" {
  description = "The ARN of the EnabledControl resource."
  value       = aws_controltower_control.this.arn
}

output "id" {
  description = "The ARN of the organizational unit."
  value       = aws_controltower_control.this.id
}