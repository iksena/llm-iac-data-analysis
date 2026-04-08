output "arn" {
  description = "ARN of the attachment."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.arn
}

output "peer_account_id" {
  description = "Identifier of the peer AWS account."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.peer_account_id
}

output "peer_region" {
  description = "Identifier of the peer AWS region."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.peer_region
}

output "peer_transit_gateway_id" {
  description = "Identifier of the peer EC2 Transit Gateway."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.peer_transit_gateway_id
}

output "transit_gateway_id" {
  description = "Identifier of the local EC2 Transit Gateway."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.transit_gateway_id
}

output "id" {
  description = "Identifier of the EC2 Transit Gateway Peering Attachment."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.region
}

output "tags" {
  description = "Mapping of tags assigned to the resource."
  value       = data.aws_ec2_transit_gateway_peering_attachment.this.tags
}

output "filter" {
  description = "Configuration blocks containing name-values filters used."
  value       = var.filter
}