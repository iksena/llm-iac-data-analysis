output "arn" {
  description = "The Amazon Resource Name (ARN) of the Query Logging Config"
  value       = aws_route53_query_log.this.arn
}

output "id" {
  description = "The query logging configuration ID"
  value       = aws_route53_query_log.this.id
}