output "arn" {
  description = "ARN of the subscription"
  value       = aws_sns_topic_subscription.this.arn
}

output "confirmation_was_authenticated" {
  description = "Whether the subscription confirmation request was authenticated"
  value       = aws_sns_topic_subscription.this.confirmation_was_authenticated
}

output "id" {
  description = "ARN of the subscription"
  value       = aws_sns_topic_subscription.this.id
}

output "owner_id" {
  description = "AWS account ID of the subscription's owner"
  value       = aws_sns_topic_subscription.this.owner_id
}

output "pending_confirmation" {
  description = "Whether the subscription has not been confirmed"
  value       = aws_sns_topic_subscription.this.pending_confirmation
}