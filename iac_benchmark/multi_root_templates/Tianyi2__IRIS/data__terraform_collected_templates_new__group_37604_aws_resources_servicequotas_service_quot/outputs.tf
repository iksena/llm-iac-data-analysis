output "adjustable" {
  description = "Whether the service quota can be increased."
  value       = aws_servicequotas_service_quota.this.adjustable
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the service quota."
  value       = aws_servicequotas_service_quota.this.arn
}

output "default_value" {
  description = "Default value of the service quota."
  value       = aws_servicequotas_service_quota.this.default_value
}

output "id" {
  description = "Service code and quota code, separated by a front slash (/)."
  value       = aws_servicequotas_service_quota.this.id
}

output "quota_name" {
  description = "Name of the quota."
  value       = aws_servicequotas_service_quota.this.quota_name
}

output "service_name" {
  description = "Name of the service."
  value       = aws_servicequotas_service_quota.this.service_name
}

output "usage_metric" {
  description = "Information about the measurement."
  value       = aws_servicequotas_service_quota.this.usage_metric
}

output "usage_metric_metric_dimensions" {
  description = "The metric dimensions."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_dimensions
}

output "usage_metric_metric_dimensions_class" {
  description = "The metric dimensions class."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_dimensions[*].class
}

output "usage_metric_metric_dimensions_resource" {
  description = "The metric dimensions resource."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_dimensions[*].resource
}

output "usage_metric_metric_dimensions_service" {
  description = "The metric dimensions service."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_dimensions[*].service
}

output "usage_metric_metric_dimensions_type" {
  description = "The metric dimensions type."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_dimensions[*].type
}

output "usage_metric_metric_name" {
  description = "The name of the metric."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_name
}

output "usage_metric_metric_namespace" {
  description = "The namespace of the metric."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_namespace
}

output "usage_metric_metric_statistic_recommendation" {
  description = "The metric statistic that AWS recommend you use when determining quota usage."
  value       = aws_servicequotas_service_quota.this.usage_metric[*].metric_statistic_recommendation
}