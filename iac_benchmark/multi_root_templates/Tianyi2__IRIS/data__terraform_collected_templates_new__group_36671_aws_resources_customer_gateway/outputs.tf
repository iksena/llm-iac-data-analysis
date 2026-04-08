output "id" {
  description = "The amazon-assigned ID of the gateway."
  value       = aws_customer_gateway.this.id
}

output "arn" {
  description = "The ARN of the customer gateway."
  value       = aws_customer_gateway.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_customer_gateway.this.tags_all
}