output "id" {
  description = "The Amazon Resource Name (ARN) of the custom routing listener"
  value       = aws_globalaccelerator_custom_routing_listener.this.id
}

output "accelerator_arn" {
  description = "The Amazon Resource Name (ARN) of the custom routing accelerator"
  value       = aws_globalaccelerator_custom_routing_listener.this.accelerator_arn
}

output "port_ranges" {
  description = "The list of port ranges for the connections from clients to the accelerator"
  value       = aws_globalaccelerator_custom_routing_listener.this.port_range
}