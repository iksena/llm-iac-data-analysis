
output "service_id" {
  description = "ID of the endpoint service."
  value       = aws_vpc_endpoint_service_private_dns_verification.this.service_id
}