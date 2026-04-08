output "ip_address" {
  description = "Allocated static IP address"
  value       = aws_lightsail_static_ip_attachment.this.ip_address
}

output "instance_name" {
  description = "Name of the Lightsail instance to attach the IP to"
  value       = aws_lightsail_static_ip_attachment.this.instance_name
}

output "static_ip_name" {
  description = "Name of the allocated static IP"
  value       = aws_lightsail_static_ip_attachment.this.static_ip_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_lightsail_static_ip_attachment.this.region
}