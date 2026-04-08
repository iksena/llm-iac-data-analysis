output "arn" {
  description = "ARN of the Lightsail instance"
  value       = aws_lightsail_instance.this.arn
}

output "cpu_count" {
  description = "Number of vCPUs the instance has"
  value       = aws_lightsail_instance.this.cpu_count
}

output "created_at" {
  description = "Timestamp when the instance was created"
  value       = aws_lightsail_instance.this.created_at
}

output "id" {
  description = "ARN of the Lightsail instance (matches arn)"
  value       = aws_lightsail_instance.this.id
}

output "ipv6_addresses" {
  description = "List of IPv6 addresses for the Lightsail instance"
  value       = aws_lightsail_instance.this.ipv6_addresses
}

output "is_static_ip" {
  description = "Whether this instance has a static IP assigned to it"
  value       = aws_lightsail_instance.this.is_static_ip
}

output "private_ip_address" {
  description = "Private IP address of the instance"
  value       = aws_lightsail_instance.this.private_ip_address
}

output "public_ip_address" {
  description = "Public IP address of the instance"
  value       = aws_lightsail_instance.this.public_ip_address
}

output "ram_size" {
  description = "Amount of RAM in GB on the instance"
  value       = aws_lightsail_instance.this.ram_size
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider"
  value       = aws_lightsail_instance.this.tags_all
}

output "username" {
  description = "User name for connecting to the instance"
  value       = aws_lightsail_instance.this.username
}