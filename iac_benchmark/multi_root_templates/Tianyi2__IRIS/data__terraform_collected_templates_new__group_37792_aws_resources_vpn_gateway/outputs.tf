output "arn" {
  description = "Amazon Resource Name (ARN) of the VPN Gateway."
  value       = aws_vpn_gateway.this.arn
}

output "id" {
  description = "The ID of the VPN Gateway."
  value       = aws_vpn_gateway.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpn_gateway.this.tags_all
}