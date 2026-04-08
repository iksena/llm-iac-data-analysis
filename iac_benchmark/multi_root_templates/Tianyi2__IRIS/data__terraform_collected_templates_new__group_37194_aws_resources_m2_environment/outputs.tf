output "arn" {
  description = "ARN of the Environment."
  value       = aws_m2_environment.this.arn
}

output "id" {
  description = "The id of the Environment."
  value       = aws_m2_environment.this.id
}

output "environment_id" {
  description = "The id of the Environment."
  value       = aws_m2_environment.this.environment_id
}

output "load_balancer_arn" {
  description = "ARN of the load balancer created by the Environment."
  value       = aws_m2_environment.this.load_balancer_arn
}

output "name" {
  description = "Name of the runtime environment."
  value       = aws_m2_environment.this.name
}

output "engine_type" {
  description = "Engine type of the environment."
  value       = aws_m2_environment.this.engine_type
}

output "instance_type" {
  description = "M2 Instance Type of the environment."
  value       = aws_m2_environment.this.instance_type
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_m2_environment.this.tags_all
}