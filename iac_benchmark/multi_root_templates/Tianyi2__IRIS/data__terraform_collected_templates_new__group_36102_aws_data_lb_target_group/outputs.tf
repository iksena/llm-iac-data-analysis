output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_lb_target_group.this.region
}

output "arn" {
  description = "Full ARN of the target group."
  value       = data.aws_lb_target_group.this.arn
}

output "name" {
  description = "Unique name of the target group."
  value       = data.aws_lb_target_group.this.name
}

output "tags" {
  description = "Mapping of tags assigned to the target group."
  value       = data.aws_lb_target_group.this.tags
}

output "arn_suffix" {
  description = "ARN suffix for use with CloudWatch Metrics."
  value       = data.aws_lb_target_group.this.arn_suffix
}

output "deregistration_delay" {
  description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
  value       = data.aws_lb_target_group.this.deregistration_delay
}

output "health_check" {
  description = "Health check configuration."
  value       = data.aws_lb_target_group.this.health_check
}

output "load_balancer_arns" {
  description = "ARNs of the load balancers associated with the target group."
  value       = data.aws_lb_target_group.this.load_balancer_arns
}

output "port" {
  description = "Port on which targets receive traffic."
  value       = data.aws_lb_target_group.this.port
}

output "protocol" {
  description = "Protocol to use for routing traffic to the targets."
  value       = data.aws_lb_target_group.this.protocol
}

output "protocol_version" {
  description = "Protocol version."
  value       = data.aws_lb_target_group.this.protocol_version
}

output "slow_start" {
  description = "Amount time for targets to warm up before the load balancer sends them a full share of requests."
  value       = data.aws_lb_target_group.this.slow_start
}

output "stickiness" {
  description = "Stickiness configuration."
  value       = data.aws_lb_target_group.this.stickiness
}

output "target_type" {
  description = "Type of target that you must specify when registering targets with this target group."
  value       = data.aws_lb_target_group.this.target_type
}

output "vpc_id" {
  description = "Identifier of the VPC in which the target group is created."
  value       = data.aws_lb_target_group.this.vpc_id
}