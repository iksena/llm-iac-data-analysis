output "delivery_destination_name" {
  description = "The name of the delivery destination to assign this policy to."
  value       = aws_cloudwatch_log_delivery_destination_policy.this.delivery_destination_name
}

output "delivery_destination_policy" {
  description = "The contents of the policy."
  value       = aws_cloudwatch_log_delivery_destination_policy.this.delivery_destination_policy
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_cloudwatch_log_delivery_destination_policy.this.region
}