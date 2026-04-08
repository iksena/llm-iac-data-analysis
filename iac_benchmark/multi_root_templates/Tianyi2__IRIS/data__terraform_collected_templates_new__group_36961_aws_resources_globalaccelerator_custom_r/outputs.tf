output "id" {
  description = "The Amazon Resource Name (ARN) of the custom routing endpoint group."
  value       = aws_globalaccelerator_custom_routing_endpoint_group.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the custom routing endpoint group."
  value       = aws_globalaccelerator_custom_routing_endpoint_group.this.arn
}