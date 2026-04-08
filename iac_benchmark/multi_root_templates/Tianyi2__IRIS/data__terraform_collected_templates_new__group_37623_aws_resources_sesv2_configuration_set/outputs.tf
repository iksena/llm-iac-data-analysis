output "arn" {
  description = "ARN of the Configuration Set."
  value       = aws_sesv2_configuration_set.this.arn
}

output "reputation_options" {
  description = "An object that defines whether or not Amazon SES collects reputation metrics for the emails that you send that use the configuration set."
  value       = aws_sesv2_configuration_set.this.reputation_options
}

output "last_fresh_start" {
  description = "The date and time (in Unix time) when the reputation metrics were last given a fresh start."
  value       = try(aws_sesv2_configuration_set.this.reputation_options[0].last_fresh_start, null)
}