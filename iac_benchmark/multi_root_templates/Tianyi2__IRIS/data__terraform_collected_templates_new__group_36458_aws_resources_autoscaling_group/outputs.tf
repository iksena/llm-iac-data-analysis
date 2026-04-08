output "id" {
  description = "Auto Scaling Group id."
  value       = aws_autoscaling_group.this.id
}

output "arn" {
  description = "ARN for this Auto Scaling Group."
  value       = aws_autoscaling_group.this.arn
}

output "availability_zones" {
  description = "Availability zones of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.availability_zones
}

output "min_size" {
  description = "Minimum size of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.min_size
}

output "max_size" {
  description = "Maximum size of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.max_size
}

output "default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity."
  value       = aws_autoscaling_group.this.default_cooldown
}

output "default_instance_warmup" {
  description = "The duration of the default instance warmup, in seconds."
  value       = aws_autoscaling_group.this.default_instance_warmup
}

output "name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.name
}

output "health_check_grace_period" {
  description = "Time after instance comes into service before checking health."
  value       = aws_autoscaling_group.this.health_check_grace_period
}

output "health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done."
  value       = aws_autoscaling_group.this.health_check_type
}

output "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group."
  value       = aws_autoscaling_group.this.desired_capacity
}

output "launch_configuration" {
  description = "The launch configuration of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.launch_configuration
}

output "predicted_capacity" {
  description = "Predicted capacity of the group."
  value       = aws_autoscaling_group.this.predicted_capacity
}

output "vpc_zone_identifier" {
  description = "The VPC zone identifier."
  value       = aws_autoscaling_group.this.vpc_zone_identifier
}

output "warm_pool_size" {
  description = "Current size of the warm pool."
  value       = aws_autoscaling_group.this.warm_pool_size
}