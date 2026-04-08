output "arn" {
  description = "SES configuration set ARN."
  value       = aws_ses_configuration_set.this.arn
}

output "id" {
  description = "SES configuration set name."
  value       = aws_ses_configuration_set.this.id
}

output "last_fresh_start" {
  description = "Date and time at which the reputation metrics for the configuration set were last reset. Resetting these metrics is known as a fresh start."
  value       = aws_ses_configuration_set.this.last_fresh_start
}