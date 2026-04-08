
output "aws_account_id" {
  description = "AWS account ID."
  value       = aws_quicksight_account_settings.this.aws_account_id
}

output "default_namespace" {
  description = "The default namespace for this Amazon Web Services account."
  value       = aws_quicksight_account_settings.this.default_namespace
}

output "termination_protection_enabled" {
  description = "Whether or not an Amazon QuickSight account can be deleted."
  value       = aws_quicksight_account_settings.this.termination_protection_enabled
}