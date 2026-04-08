output "id" {
  description = "The Amazon Resource Name (ARN) of the custom accelerator."
  value       = aws_globalaccelerator_custom_routing_accelerator.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the custom accelerator."
  value       = aws_globalaccelerator_custom_routing_accelerator.this.arn
}

output "dns_name" {
  description = "The DNS name of the accelerator. For example, a5d53ff5ee6bca4ce.awsglobalaccelerator.com."
  value       = aws_globalaccelerator_custom_routing_accelerator.this.dns_name
}

output "hosted_zone_id" {
  description = "The Global Accelerator Route 53 zone ID that can be used to route an Alias Resource Record Set to the Global Accelerator. This attribute is simply an alias for the zone ID Z2BJ6XQ5FK7U4H."
  value       = aws_globalaccelerator_custom_routing_accelerator.this.hosted_zone_id
}

output "ip_sets" {
  description = "IP address set associated with the accelerator."
  value       = aws_globalaccelerator_custom_routing_accelerator.this.ip_sets
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_globalaccelerator_custom_routing_accelerator.this.tags_all
}