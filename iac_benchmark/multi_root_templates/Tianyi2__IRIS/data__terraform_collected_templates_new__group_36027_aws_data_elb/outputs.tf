output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_elb.this.region
}

output "name" {
  description = "Unique name of the load balancer."
  value       = data.aws_elb.this.name
}

output "arn" {
  description = "The ARN of the ELB."
  value       = data.aws_elb.this.arn
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = data.aws_elb.this.dns_name
}

output "zone_id" {
  description = "The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)."
  value       = data.aws_elb.this.zone_id
}

output "security_groups" {
  description = "A list of security group IDs assigned to the ELB."
  value       = data.aws_elb.this.security_groups
}

output "subnets" {
  description = "A list of subnet IDs attached to the ELB."
  value       = data.aws_elb.this.subnets
}

output "instances" {
  description = "A list of instance ids to place in the ELB pool."
  value       = data.aws_elb.this.instances
}

output "availability_zones" {
  description = "The list of Availability Zones which were specified for this ELB."
  value       = data.aws_elb.this.availability_zones
}

output "source_security_group" {
  description = "The name of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances."
  value       = data.aws_elb.this.source_security_group
}

output "source_security_group_id" {
  description = "The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances."
  value       = data.aws_elb.this.source_security_group_id
}

output "access_logs" {
  description = "An Access Logs block."
  value       = data.aws_elb.this.access_logs
}

output "connection_draining" {
  description = "Boolean to enable connection draining."
  value       = data.aws_elb.this.connection_draining
}

output "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain."
  value       = data.aws_elb.this.connection_draining_timeout
}

output "cross_zone_load_balancing" {
  description = "True if cross-zone load balancing is enabled for the load balancer."
  value       = data.aws_elb.this.cross_zone_load_balancing
}

output "desync_mitigation_mode" {
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync."
  value       = data.aws_elb.this.desync_mitigation_mode
}

output "health_check" {
  description = "A health_check block."
  value       = data.aws_elb.this.health_check
}

output "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  value       = data.aws_elb.this.idle_timeout
}

output "listener" {
  description = "A list of listener blocks."
  value       = data.aws_elb.this.listener
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = data.aws_elb.this.tags
}