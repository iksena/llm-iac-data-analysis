output "arn" {
  description = "The ARN of the load balancer."
  value       = data.aws_lb.this.arn
}

output "arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics."
  value       = data.aws_lb.this.arn_suffix
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = data.aws_lb.this.dns_name
}

output "zone_id" {
  description = "The canonical hosted zone ID of the load balancer."
  value       = data.aws_lb.this.zone_id
}

output "name" {
  description = "The name of the load balancer."
  value       = data.aws_lb.this.name
}

output "load_balancer_type" {
  description = "The type of load balancer."
  value       = data.aws_lb.this.load_balancer_type
}

output "internal" {
  description = "Boolean determining if the load balancer is internal or external."
  value       = data.aws_lb.this.internal
}

output "security_groups" {
  description = "The security groups for the load balancer."
  value       = data.aws_lb.this.security_groups
}

output "subnets" {
  description = "The subnets for the load balancer."
  value       = data.aws_lb.this.subnets
}

output "subnet_mapping" {
  description = "The subnet mapping for the load balancer."
  value       = data.aws_lb.this.subnet_mapping
}

output "vpc_id" {
  description = "The VPC ID of the load balancer."
  value       = data.aws_lb.this.vpc_id
}

output "ip_address_type" {
  description = "The type of IP addresses used by the subnets for the load balancer."
  value       = data.aws_lb.this.ip_address_type
}

output "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  value       = data.aws_lb.this.idle_timeout
}

output "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
  value       = data.aws_lb.this.enable_deletion_protection
}

output "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled."
  value       = data.aws_lb.this.enable_cross_zone_load_balancing
}

output "enable_http2" {
  description = "If true, HTTP/2 is enabled in application load balancers."
  value       = data.aws_lb.this.enable_http2
}

output "enable_waf_fail_open" {
  description = "If true, allows a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF."
  value       = data.aws_lb.this.enable_waf_fail_open
}

output "preserve_host_header" {
  description = "If true, the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change."
  value       = data.aws_lb.this.preserve_host_header
}

output "access_logs" {
  description = "An access logs block."
  value       = data.aws_lb.this.access_logs
}

output "connection_logs" {
  description = "A connection logs block."
  value       = data.aws_lb.this.connection_logs
}

output "customer_owned_ipv4_pool" {
  description = "The ID of the customer owned ipv4 pool to use for this load balancer."
  value       = data.aws_lb.this.customer_owned_ipv4_pool
}

output "desync_mitigation_mode" {
  description = "Determines how the load balancer handles requests that might pose a security risk to an application."
  value       = data.aws_lb.this.desync_mitigation_mode
}

output "drop_invalid_header_fields" {
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer."
  value       = data.aws_lb.this.drop_invalid_header_fields
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = data.aws_lb.this.tags
}

