output "id" {
  description = "The Amazon Resource Name (ARN) of the endpoint group"
  value       = aws_globalaccelerator_endpoint_group.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the endpoint group"
  value       = aws_globalaccelerator_endpoint_group.this.arn
}