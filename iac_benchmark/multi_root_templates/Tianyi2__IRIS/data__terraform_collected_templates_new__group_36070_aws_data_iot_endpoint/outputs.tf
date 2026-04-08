output "endpoint_address" {
  description = "Endpoint based on endpoint_type"
  value       = data.aws_iot_endpoint.this.endpoint_address
}