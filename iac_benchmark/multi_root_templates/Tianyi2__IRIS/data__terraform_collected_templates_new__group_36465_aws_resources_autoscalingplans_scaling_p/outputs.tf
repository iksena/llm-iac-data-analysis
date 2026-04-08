output "id" {
  description = "Scaling plan identifier."
  value       = aws_autoscalingplans_scaling_plan.this.id
}

output "scaling_plan_version" {
  description = "The version number of the scaling plan. This value is always 1."
  value       = aws_autoscalingplans_scaling_plan.this.scaling_plan_version
}