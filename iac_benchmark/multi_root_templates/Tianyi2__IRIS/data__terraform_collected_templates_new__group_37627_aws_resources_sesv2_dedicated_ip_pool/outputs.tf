output "arn" {
  description = "ARN of the Dedicated IP Pool"
  value       = aws_sesv2_dedicated_ip_pool.this.arn
}