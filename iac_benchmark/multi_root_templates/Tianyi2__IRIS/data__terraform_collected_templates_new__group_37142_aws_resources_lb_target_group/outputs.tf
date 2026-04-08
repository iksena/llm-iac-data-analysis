output "arn_suffix" {
  description = "ARN suffix for use with CloudWatch Metrics"
  value       = aws_lb_target_group.this.arn_suffix
}

output "arn" {
  description = "ARN of the Target Group (matches id)"
  value       = aws_lb_target_group.this.arn
}

output "id" {
  description = "ARN of the Target Group (matches arn)"
  value       = aws_lb_target_group.this.id
}

output "name" {
  description = "Name of the Target Group"
  value       = aws_lb_target_group.this.name
}

output "load_balancer_arns" {
  description = "ARNs of the Load Balancers associated with the Target Group"
  value       = aws_lb_target_group.this.load_balancer_arns
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lb_target_group.this.tags_all
}