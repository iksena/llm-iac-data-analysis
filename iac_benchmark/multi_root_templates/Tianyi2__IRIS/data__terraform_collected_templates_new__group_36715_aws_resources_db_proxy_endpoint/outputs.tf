output "id" {
  description = "The name of the proxy and proxy endpoint separated by /, DB-PROXY-NAME/DB-PROXY-ENDPOINT-NAME."
  value       = aws_db_proxy_endpoint.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) for the proxy endpoint."
  value       = aws_db_proxy_endpoint.this.arn
}

output "endpoint" {
  description = "The endpoint that you can use to connect to the proxy. You include the endpoint value in the connection string for a database client application."
  value       = aws_db_proxy_endpoint.this.endpoint
}

output "is_default" {
  description = "Indicates whether this endpoint is the default endpoint for the associated DB proxy."
  value       = aws_db_proxy_endpoint.this.is_default
}

output "vpc_id" {
  description = "The VPC ID of the DB proxy endpoint."
  value       = aws_db_proxy_endpoint.this.vpc_id
}