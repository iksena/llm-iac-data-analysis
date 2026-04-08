output "arn" {
  description = "The ARN of the Billing Group."
  value       = aws_iot_billing_group.this.arn
}

output "id" {
  description = "The Billing Group ID."
  value       = aws_iot_billing_group.this.id
}

output "version" {
  description = "The current version of the Billing Group record in the registry."
  value       = aws_iot_billing_group.this.version
}