output "arn" {
  description = "ARN of the Lightsail load balancer"
  value       = aws_lightsail_lb.this.arn
}

output "created_at" {
  description = "Timestamp when the load balancer was created"
  value       = aws_lightsail_lb.this.created_at
}

output "dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lightsail_lb.this.dns_name
}

output "id" {
  description = "Name used for this load balancer (matches name)"
  value       = aws_lightsail_lb.this.id
}

output "protocol" {
  description = "Protocol of the load balancer"
  value       = aws_lightsail_lb.this.protocol
}

output "public_ports" {
  description = "Public ports of the load balancer"
  value       = aws_lightsail_lb.this.public_ports
}

output "support_code" {
  description = "Support code for the load balancer"
  value       = aws_lightsail_lb.this.support_code
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lightsail_lb.this.tags_all
}