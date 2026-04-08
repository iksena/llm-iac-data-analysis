output "global_quota" {
  description = "Indicates whether the quota is global"
  value       = aws_servicequotas_template.this.global_quota
}

output "id" {
  description = "Unique identifier for the resource, which is a comma-delimited string separating region, quota_code, and service_code"
  value       = aws_servicequotas_template.this.id
}

output "quota_name" {
  description = "Quota name"
  value       = aws_servicequotas_template.this.quota_name
}

output "service_name" {
  description = "Service name"
  value       = aws_servicequotas_template.this.service_name
}

output "unit" {
  description = "Unit of measurement"
  value       = aws_servicequotas_template.this.unit
}