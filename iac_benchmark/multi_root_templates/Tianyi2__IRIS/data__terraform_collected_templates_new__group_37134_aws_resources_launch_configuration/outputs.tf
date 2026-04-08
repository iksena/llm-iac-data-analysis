output "id" {
  description = "The ID of the launch configuration"
  value       = aws_launch_configuration.this.id
}

output "arn" {
  description = "The Amazon Resource Name of the launch configuration"
  value       = aws_launch_configuration.this.arn
}

output "name" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.this.name
}