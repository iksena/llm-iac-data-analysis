output "account_subscription_status" {
  description = "Status of the Amazon QuickSight account's subscription."
  value       = aws_quicksight_account_subscription.this.account_subscription_status
}