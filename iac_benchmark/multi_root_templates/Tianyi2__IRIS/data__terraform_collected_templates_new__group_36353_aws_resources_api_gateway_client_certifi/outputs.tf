output "id" {
  description = "Identifier of the client certificate"
  value       = aws_api_gateway_client_certificate.this.id
}

output "created_date" {
  description = "Date when the client certificate was created"
  value       = aws_api_gateway_client_certificate.this.created_date
}

output "expiration_date" {
  description = "Date when the client certificate will expire"
  value       = aws_api_gateway_client_certificate.this.expiration_date
}

output "pem_encoded_certificate" {
  description = "The PEM-encoded public key of the client certificate"
  value       = aws_api_gateway_client_certificate.this.pem_encoded_certificate
}

output "arn" {
  description = "ARN"
  value       = aws_api_gateway_client_certificate.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_api_gateway_client_certificate.this.tags_all
}