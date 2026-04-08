
output "transit_gateway_attachment_id" {
  description = "The unique identifier of the transit gateway attachment."
  value       = aws_networkfirewall_firewall_transit_gateway_attachment_accepter.this.transit_gateway_attachment_id
}

output "region" {
  description = "The region where the resource is managed."
  value       = aws_networkfirewall_firewall_transit_gateway_attachment_accepter.this.region
}