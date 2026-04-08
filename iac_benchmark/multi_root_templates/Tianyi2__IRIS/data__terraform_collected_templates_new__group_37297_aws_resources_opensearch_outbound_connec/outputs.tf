output "id" {
  description = "The Id of the connection."
  value       = aws_opensearch_outbound_connection.this.id
}

output "connection_status" {
  description = "Status of the connection request."
  value       = aws_opensearch_outbound_connection.this.connection_status
}

output "connection_properties_endpoint" {
  description = "The endpoint of the remote domain, is only set when connection_mode is VPC_ENDPOINT and accept_connection is TRUE."
  value       = try(aws_opensearch_outbound_connection.this.connection_properties[0].endpoint, null)
}