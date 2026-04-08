output "authorized_principal" {
  description = "Information about the Amazon Web Services account or service that was provided access to the domain."
  value       = aws_opensearch_authorize_vpc_endpoint_access.this.authorized_principal
}

output "principal" {
  description = "IAM principal that is allowed to access to the domain."
  value       = aws_opensearch_authorize_vpc_endpoint_access.this.authorized_principal[0].principal
}

output "principal_type" {
  description = "Type of principal."
  value       = aws_opensearch_authorize_vpc_endpoint_access.this.authorized_principal[0].principal_type
}