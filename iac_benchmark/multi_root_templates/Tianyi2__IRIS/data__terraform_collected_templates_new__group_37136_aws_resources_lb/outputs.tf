output "arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "arn_suffix" {
  description = "ARN suffix for use with CloudWatch Metrics"
  value       = aws_lb.this.arn_suffix
}

output "dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "subnet_mapping_outpost_id" {
  description = "ID of the Outpost containing the load balancer"
  value       = aws_lb.this.subnet_mapping.*.outpost_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lb.this.tags_all
}

output "zone_id" {
  description = "Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)"
  value       = aws_lb.this.zone_id
}