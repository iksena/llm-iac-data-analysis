output "id" {
  description = "The name of the RDS event notification subscription"
  value       = aws_db_event_subscription.this.id
}

output "arn" {
  description = "The Amazon Resource Name of the RDS event notification subscription"
  value       = aws_db_event_subscription.this.arn
}

output "customer_aws_id" {
  description = "The AWS customer account associated with the RDS event notification subscription"
  value       = aws_db_event_subscription.this.customer_aws_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_db_event_subscription.this.tags_all
}