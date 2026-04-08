output "arn" {
  description = "ARN of the Lightsail domain"
  value       = aws_lightsail_domain.this.arn
}

output "id" {
  description = "Name used for this domain"
  value       = aws_lightsail_domain.this.id
}