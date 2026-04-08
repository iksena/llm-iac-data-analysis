output "customer_gateway_arn" {
  description = "ARN of the customer gateway"
  value       = aws_networkmanager_customer_gateway_association.this.customer_gateway_arn
}

output "device_id" {
  description = "ID of the device"
  value       = aws_networkmanager_customer_gateway_association.this.device_id
}

output "global_network_id" {
  description = "ID of the global network"
  value       = aws_networkmanager_customer_gateway_association.this.global_network_id
}

output "link_id" {
  description = "ID of the link"
  value       = aws_networkmanager_customer_gateway_association.this.link_id
}