output "id" {
  description = "Code of the service."
  value       = data.aws_servicequotas_service.this.id
}

output "service_code" {
  description = "Code of the service."
  value       = data.aws_servicequotas_service.this.service_code
}