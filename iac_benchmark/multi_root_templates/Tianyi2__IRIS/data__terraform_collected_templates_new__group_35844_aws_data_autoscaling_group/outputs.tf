output "arn" {
  description = "ARN of the Auto Scaling group."
  value       = data.aws_autoscaling_group.this.arn
}

output "availability_zones" {
  description = "One or more Availability Zones for the group."
  value       = data.aws_autoscaling_group.this.availability_zones
}

output "default_cool_down" {
  description = "Amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
  value       = data.aws_autoscaling_group.this.default_cooldown
}

output "desired_capacity" {
  description = "Desired size of the group."
  value       = data.aws_autoscaling_group.this.desired_capacity
}

output "desired_capacity_type" {
  description = "The unit of measurement for the value returned for desired_capacity."
  value       = data.aws_autoscaling_group.this.desired_capacity_type
}

output "enabled_metrics" {
  description = "List of metrics enabled for collection."
  value       = data.aws_autoscaling_group.this.enabled_metrics
}

output "health_check_grace_period" {
  description = "The amount of time, in seconds, that Amazon EC2 Auto Scaling waits before checking the health status of an EC2 instance that has come into service."
  value       = data.aws_autoscaling_group.this.health_check_grace_period
}

output "health_check_type" {
  description = "Service to use for the health checks. The valid values are EC2 and ELB."
  value       = data.aws_autoscaling_group.this.health_check_type
}

output "id" {
  description = "Name of the Auto Scaling Group."
  value       = data.aws_autoscaling_group.this.id
}

output "instance_maintenance_policy" {
  description = "Instance maintenance policy for the group."
  value       = data.aws_autoscaling_group.this.instance_maintenance_policy
}

output "launch_configuration" {
  description = "The name of the associated launch configuration."
  value       = data.aws_autoscaling_group.this.launch_configuration
}

output "launch_template" {
  description = "List of launch templates for the group."
  value       = data.aws_autoscaling_group.this.launch_template
}

output "load_balancers" {
  description = "One or more load balancers associated with the group."
  value       = data.aws_autoscaling_group.this.load_balancers
}

output "max_instance_lifetime" {
  description = "Maximum amount of time, in seconds, that an instance can be in service."
  value       = data.aws_autoscaling_group.this.max_instance_lifetime
}

output "max_size" {
  description = "Maximum size of the group."
  value       = data.aws_autoscaling_group.this.max_size
}

output "min_size" {
  description = "Minimum size of the group."
  value       = data.aws_autoscaling_group.this.min_size
}

output "mixed_instances_policy" {
  description = "List of mixed instances policy objects for the group."
  value       = data.aws_autoscaling_group.this.mixed_instances_policy
}

output "name" {
  description = "Name of the Auto Scaling Group."
  value       = data.aws_autoscaling_group.this.name
}

output "placement_group" {
  description = "Name of the placement group into which to launch your instances, if any."
  value       = data.aws_autoscaling_group.this.placement_group
}

output "predicted_capacity" {
  description = "Predicted capacity of the group."
  value       = data.aws_autoscaling_group.this.predicted_capacity
}

output "service_linked_role_arn" {
  description = "ARN of the service-linked role that the Auto Scaling group uses to call other AWS services on your behalf."
  value       = data.aws_autoscaling_group.this.service_linked_role_arn
}

output "status" {
  description = "Current state of the group when DeleteAutoScalingGroup is in progress."
  value       = data.aws_autoscaling_group.this.status
}

output "suspended_processes" {
  description = "List of processes suspended processes for the Auto Scaling Group."
  value       = data.aws_autoscaling_group.this.suspended_processes
}

output "tag" {
  description = "List of tags for the group."
  value       = data.aws_autoscaling_group.this.tag
}

output "target_group_arns" {
  description = "ARNs of the target groups for your load balancer."
  value       = data.aws_autoscaling_group.this.target_group_arns
}

output "termination_policies" {
  description = "The termination policies for the group."
  value       = data.aws_autoscaling_group.this.termination_policies
}

output "traffic_source" {
  description = "Traffic sources."
  value       = data.aws_autoscaling_group.this.traffic_source
}

output "vpc_zone_identifier" {
  description = "VPC ID for the group."
  value       = data.aws_autoscaling_group.this.vpc_zone_identifier
}

output "warm_pool" {
  description = "List of warm pool configuration objects."
  value       = data.aws_autoscaling_group.this.warm_pool
}

output "warm_pool_size" {
  description = "Current size of the warm pool."
  value       = data.aws_autoscaling_group.this.warm_pool_size
}