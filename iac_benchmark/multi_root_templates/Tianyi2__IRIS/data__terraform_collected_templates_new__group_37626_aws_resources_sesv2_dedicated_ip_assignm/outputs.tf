output "id" {
  description = "A comma-separated string made up of ip and destination_pool_name"
  value       = aws_sesv2_dedicated_ip_assignment.this.id
}

output "ip" {
  description = "Dedicated IP address"
  value       = aws_sesv2_dedicated_ip_assignment.this.ip
}

output "destination_pool_name" {
  description = "Dedicated IP pool name"
  value       = aws_sesv2_dedicated_ip_assignment.this.destination_pool_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_sesv2_dedicated_ip_assignment.this.region
}