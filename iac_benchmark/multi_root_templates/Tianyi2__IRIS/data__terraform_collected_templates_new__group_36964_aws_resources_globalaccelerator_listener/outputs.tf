output "id" {
  description = "The Amazon Resource Name (ARN) of the listener."
  value       = aws_globalaccelerator_listener.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the listener."
  value       = aws_globalaccelerator_listener.this.arn
}