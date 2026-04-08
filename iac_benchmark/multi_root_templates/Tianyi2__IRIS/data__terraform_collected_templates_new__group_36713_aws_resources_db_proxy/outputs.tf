output "id" {
  description = "The Amazon Resource Name (ARN) for the proxy"
  value       = aws_db_proxy.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) for the proxy"
  value       = aws_db_proxy.this.arn
}

output "endpoint" {
  description = "The endpoint that you can use to connect to the proxy"
  value       = aws_db_proxy.this.endpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_db_proxy.this.tags_all
}