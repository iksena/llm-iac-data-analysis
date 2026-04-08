output "id" {
  description = "The unique identifier of the endpoint."
  value       = aws_opensearch_vpc_endpoint.this.id
}

output "endpoint" {
  description = "The connection endpoint ID for connecting to the domain."
  value       = aws_opensearch_vpc_endpoint.this.endpoint
}