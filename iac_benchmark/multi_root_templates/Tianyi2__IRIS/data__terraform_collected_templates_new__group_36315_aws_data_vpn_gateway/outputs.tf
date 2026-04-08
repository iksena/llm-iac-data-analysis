output "id" {
  description = "The ID of the VPN Gateway."
  value       = data.aws_vpn_gateway.this.id
}

output "state" {
  description = "The state of the VPN Gateway."
  value       = data.aws_vpn_gateway.this.state
}

output "availability_zone" {
  description = "The Availability Zone of the VPN Gateway."
  value       = data.aws_vpn_gateway.this.availability_zone
}

output "attached_vpc_id" {
  description = "The ID of the VPC attached to the VPN Gateway."
  value       = data.aws_vpn_gateway.this.attached_vpc_id
}

output "tags" {
  description = "A map of tags assigned to the VPN Gateway."
  value       = data.aws_vpn_gateway.this.tags
}

output "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the VPN Gateway."
  value       = data.aws_vpn_gateway.this.amazon_side_asn
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the VPN Gateway."
  value       = data.aws_vpn_gateway.this.arn
}