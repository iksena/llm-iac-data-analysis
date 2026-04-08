output "adjustable" {
  description = "Whether the service quota is adjustable."
  value       = data.aws_servicequotas_service_quota.this.adjustable
}

output "arn" {
  description = "ARN of the service quota."
  value       = data.aws_servicequotas_service_quota.this.arn
}

output "default_value" {
  description = "Default value of the service quota."
  value       = data.aws_servicequotas_service_quota.this.default_value
}

output "global_quota" {
  description = "Whether the service quota is global for the AWS account."
  value       = data.aws_servicequotas_service_quota.this.global_quota
}

output "id" {
  description = "ARN of the service quota."
  value       = data.aws_servicequotas_service_quota.this.id
}

output "service_name" {
  description = "Name of the service."
  value       = data.aws_servicequotas_service_quota.this.service_name
}

output "usage_metric" {
  description = "Information about the measurement."
  value       = data.aws_servicequotas_service_quota.this.usage_metric
}

output "value" {
  description = "Current value of the service quota."
  value       = data.aws_servicequotas_service_quota.this.value
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_servicequotas_service_quota.this.region
}

output "service_code" {
  description = "Service code for the quota."
  value       = data.aws_servicequotas_service_quota.this.service_code
}

output "quota_code" {
  description = "Quota code within the service."
  value       = data.aws_servicequotas_service_quota.this.quota_code
}

output "quota_name" {
  description = "Quota name within the service."
  value       = data.aws_servicequotas_service_quota.this.quota_name
}