output "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session."
  value       = data.aws_ec2_transit_gateway.this.amazon_side_asn
}

output "arn" {
  description = "EC2 Transit Gateway ARN."
  value       = data.aws_ec2_transit_gateway.this.arn
}

output "association_default_route_table_id" {
  description = "Identifier of the default association route table."
  value       = data.aws_ec2_transit_gateway.this.association_default_route_table_id
}

output "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted."
  value       = data.aws_ec2_transit_gateway.this.auto_accept_shared_attachments
}

output "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table."
  value       = data.aws_ec2_transit_gateway.this.default_route_table_association
}

output "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table."
  value       = data.aws_ec2_transit_gateway.this.default_route_table_propagation
}

output "description" {
  description = "Description of the EC2 Transit Gateway."
  value       = data.aws_ec2_transit_gateway.this.description
}

output "dns_support" {
  description = "Whether DNS support is enabled."
  value       = data.aws_ec2_transit_gateway.this.dns_support
}

output "security_group_referencing_support" {
  description = "Whether Security Group Referencing Support is enabled."
  value       = data.aws_ec2_transit_gateway.this.security_group_referencing_support
}

output "multicast_support" {
  description = "Whether Multicast support is enabled."
  value       = data.aws_ec2_transit_gateway.this.multicast_support
}

output "id" {
  description = "EC2 Transit Gateway identifier."
  value       = data.aws_ec2_transit_gateway.this.id
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway."
  value       = data.aws_ec2_transit_gateway.this.owner_id
}

output "propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table."
  value       = data.aws_ec2_transit_gateway.this.propagation_default_route_table_id
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway."
  value       = data.aws_ec2_transit_gateway.this.tags
}

output "transit_gateway_cidr_blocks" {
  description = "The list of associated CIDR blocks."
  value       = data.aws_ec2_transit_gateway.this.transit_gateway_cidr_blocks
}

output "vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled."
  value       = data.aws_ec2_transit_gateway.this.vpn_ecmp_support
}