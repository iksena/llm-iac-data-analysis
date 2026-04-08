output "arn" {
  description = "The ARN of a resource that represents your subscription to the product that generates the findings that you want to import into Security Hub."
  value       = aws_securityhub_product_subscription.this.arn
}