output "vpc_id" {
  description = "The ID of the VPC that Virtual Private Gateway is attached to."
  value       = aws_vpn_gateway_attachment.this.vpc_id
}

output "vpn_gateway_id" {
  description = "The ID of the Virtual Private Gateway."
  value       = aws_vpn_gateway_attachment.this.vpn_gateway_id
}