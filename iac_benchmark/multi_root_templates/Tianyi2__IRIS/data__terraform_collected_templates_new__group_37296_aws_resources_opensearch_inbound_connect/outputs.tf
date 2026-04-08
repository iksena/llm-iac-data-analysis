output "id" {
  description = "The Id of the connection to accept"
  value       = aws_opensearch_inbound_connection_accepter.this.id
}

output "connection_status" {
  description = "Status of the connection request"
  value       = aws_opensearch_inbound_connection_accepter.this.connection_status
}