output "id" {
  description = "EC2 Transit Gateway Attachment identifier"
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.tags_all
}

output "appliance_mode_support" {
  description = "Whether Appliance Mode support is enabled. Valid values: disable, enable."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.appliance_mode_support
}

output "dns_support" {
  description = "Whether DNS support is enabled. Valid values: disable, enable."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.dns_support
}

output "security_group_referencing_support" {
  description = "Whether Security Group Referencing Support is enabled. Valid values: disable, enable."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.security_group_referencing_support
}

output "ipv6_support" {
  description = "Whether IPv6 support is enabled. Valid values: disable, enable."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.ipv6_support
}

output "subnet_ids" {
  description = "Identifiers of EC2 Subnets."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.subnet_ids
}

output "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.transit_gateway_id
}

output "vpc_id" {
  description = "Identifier of EC2 VPC."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.vpc_id
}

output "vpc_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 VPC."
  value       = aws_ec2_transit_gateway_vpc_attachment_accepter.this.vpc_owner_id
}