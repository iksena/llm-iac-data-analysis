output "arn" {
  description = "ARN of the Lightsail static IP"
  value       = aws_lightsail_static_ip.this.arn
}

output "ip_address" {
  description = "Allocated static IP address"
  value       = aws_lightsail_static_ip.this.ip_address
}

output "support_code" {
  description = "Support code for the static IP. Include this code in your email to support when you have questions about a static IP in Lightsail"
  value       = aws_lightsail_static_ip.this.support_code
}