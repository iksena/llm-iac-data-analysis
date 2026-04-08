output "id" {
  description = "Amazon Resource Name (ARN) of the gateway"
  value       = aws_storagegateway_gateway.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the gateway"
  value       = aws_storagegateway_gateway.this.arn
}

output "gateway_id" {
  description = "Identifier of the gateway"
  value       = aws_storagegateway_gateway.this.gateway_id
}

output "ec2_instance_id" {
  description = "The ID of the Amazon EC2 instance that was used to launch the gateway"
  value       = aws_storagegateway_gateway.this.ec2_instance_id
}

output "endpoint_type" {
  description = "The type of endpoint for your gateway"
  value       = aws_storagegateway_gateway.this.endpoint_type
}

output "host_environment" {
  description = "The type of hypervisor environment used by the host"
  value       = aws_storagegateway_gateway.this.host_environment
}

output "gateway_network_interface" {
  description = "An array that contains descriptions of the gateway network interfaces"
  value       = aws_storagegateway_gateway.this.gateway_network_interface
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_storagegateway_gateway.this.tags_all
}