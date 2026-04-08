output "id" {
  description = "The ID of the recommendation preferences resource"
  value       = aws_computeoptimizer_recommendation_preferences.this.id
}

output "resource_type" {
  description = "The target resource type of the recommendation preferences"
  value       = aws_computeoptimizer_recommendation_preferences.this.resource_type
}

output "scope" {
  description = "The scope of the recommendation preferences"
  value       = aws_computeoptimizer_recommendation_preferences.this.scope
}

output "region" {
  description = "The region where the resource is managed"
  value       = aws_computeoptimizer_recommendation_preferences.this.region
}

output "enhanced_infrastructure_metrics" {
  description = "The status of the enhanced infrastructure metrics recommendation preference"
  value       = aws_computeoptimizer_recommendation_preferences.this.enhanced_infrastructure_metrics
}

output "external_metrics_preference" {
  description = "The external metrics recommendation preference"
  value       = aws_computeoptimizer_recommendation_preferences.this.external_metrics_preference
}

output "inferred_workload_types" {
  description = "The status of the inferred workload types recommendation preference"
  value       = aws_computeoptimizer_recommendation_preferences.this.inferred_workload_types
}

output "look_back_period" {
  description = "The preference to control the number of days the utilization metrics are analyzed"
  value       = aws_computeoptimizer_recommendation_preferences.this.look_back_period
}

output "preferred_resource" {
  description = "The preferred resource configuration"
  value       = aws_computeoptimizer_recommendation_preferences.this.preferred_resource
}

output "savings_estimation_mode" {
  description = "The status of the savings estimation mode preference"
  value       = aws_computeoptimizer_recommendation_preferences.this.savings_estimation_mode
}

output "utilization_preference" {
  description = "The utilization preference configuration"
  value       = aws_computeoptimizer_recommendation_preferences.this.utilization_preference
}