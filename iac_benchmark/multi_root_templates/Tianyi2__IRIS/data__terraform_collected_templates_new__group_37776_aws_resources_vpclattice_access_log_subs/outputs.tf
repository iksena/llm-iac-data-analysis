output "id" {
  description = "ID of the access log subscription"
  value       = aws_vpclattice_access_log_subscription.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the access log subscription"
  value       = aws_vpclattice_access_log_subscription.this.arn
}

output "resource_arn" {
  description = "Amazon Resource Name (ARN) of the service network or service"
  value       = aws_vpclattice_access_log_subscription.this.resource_arn
}