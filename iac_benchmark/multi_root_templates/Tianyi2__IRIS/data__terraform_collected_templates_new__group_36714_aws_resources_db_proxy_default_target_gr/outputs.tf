output "id" {
  description = "Name of the RDS DB Proxy."
  value       = aws_db_proxy_default_target_group.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) representing the target group."
  value       = aws_db_proxy_default_target_group.this.arn
}

output "name" {
  description = "The name of the default target group."
  value       = aws_db_proxy_default_target_group.this.name
}