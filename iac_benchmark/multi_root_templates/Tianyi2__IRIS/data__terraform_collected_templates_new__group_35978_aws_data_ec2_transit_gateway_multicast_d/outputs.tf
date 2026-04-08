output "id" {
  description = "EC2 Transit Gateway Multicast Domain identifier."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.id
}

output "arn" {
  description = "EC2 Transit Gateway Multicast Domain ARN."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.arn
}

output "associations" {
  description = "EC2 Transit Gateway Multicast Domain Associations."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.associations
}

output "auto_accept_shared_associations" {
  description = "Whether to automatically accept cross-account subnet associations that are associated with the EC2 Transit Gateway Multicast Domain."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.auto_accept_shared_associations
}

output "igmpv2_support" {
  description = "Whether to enable Internet Group Management Protocol (IGMP) version 2 for the EC2 Transit Gateway Multicast Domain."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.igmpv2_support
}

output "members" {
  description = "EC2 Multicast Domain Group Members."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.members
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway Multicast Domain."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.owner_id
}

output "sources" {
  description = "EC2 Multicast Domain Group Sources."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.sources
}

output "static_sources_support" {
  description = "Whether to enable support for statically configuring multicast group sources for the EC2 Transit Gateway Multicast Domain."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.static_sources_support
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Multicast Domain."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.tags
}

output "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier."
  value       = data.aws_ec2_transit_gateway_multicast_domain.this.transit_gateway_id
}