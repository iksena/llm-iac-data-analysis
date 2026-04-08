output "arn" {
  description = "The ARN of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.this.arn
}

output "dns_name" {
  description = "The DNS name to be used by clients when establishing their VPN session."
  value       = aws_ec2_client_vpn_endpoint.this.dns_name
}

output "id" {
  description = "The ID of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.this.id
}

output "self_service_portal_url" {
  description = "The URL of the self-service portal."
  value       = aws_ec2_client_vpn_endpoint.this.self_service_portal_url
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_client_vpn_endpoint.this.tags_all
}