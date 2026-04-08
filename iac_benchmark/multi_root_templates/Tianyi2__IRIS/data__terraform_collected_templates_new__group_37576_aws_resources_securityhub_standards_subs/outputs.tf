output "id" {
  description = "The ARN of a resource that represents your subscription to a supported standard"
  value       = aws_securityhub_standards_subscription.this.id
}