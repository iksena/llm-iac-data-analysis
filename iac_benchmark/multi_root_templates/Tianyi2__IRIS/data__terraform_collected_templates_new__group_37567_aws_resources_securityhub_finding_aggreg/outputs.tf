output "arn" {
  description = "Amazon Resource Name (ARN) of the Security Hub finding aggregator."
  value       = aws_securityhub_finding_aggregator.this.id
}