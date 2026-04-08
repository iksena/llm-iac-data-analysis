output "arn" {
  description = "The Amazon Resource Name (ARN) of the Health Check"
  value       = aws_route53_health_check.this.arn
}

output "id" {
  description = "The id of the health check"
  value       = aws_route53_health_check.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53_health_check.this.tags_all
}