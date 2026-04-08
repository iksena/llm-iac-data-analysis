output "id" {
  description = "EC2 Transit Gateway Attachment identifier"
  value       = aws_ec2_transit_gateway_peering_attachment_accepter.this.id
}

output "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway"
  value       = aws_ec2_transit_gateway_peering_attachment_accepter.this.transit_gateway_id
}

output "peer_transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway to peer with"
  value       = aws_ec2_transit_gateway_peering_attachment_accepter.this.peer_transit_gateway_id
}

output "peer_account_id" {
  description = "Identifier of the AWS account that owns the EC2 TGW peering"
  value       = aws_ec2_transit_gateway_peering_attachment_accepter.this.peer_account_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_transit_gateway_peering_attachment_accepter.this.tags_all
}