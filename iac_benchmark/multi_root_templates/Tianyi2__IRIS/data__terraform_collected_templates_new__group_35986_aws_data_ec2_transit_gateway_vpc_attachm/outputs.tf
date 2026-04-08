output "arn" {
  description = "ARN of the attachment."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.arn
}

output "appliance_mode_support" {
  description = "Whether Appliance Mode support is enabled."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.appliance_mode_support
}

output "dns_support" {
  description = "Whether DNS support is enabled."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.dns_support
}

output "security_group_referencing_support" {
  description = "Whether Security Group Referencing Support is enabled."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.security_group_referencing_support
}

output "id" {
  description = "EC2 Transit Gateway VPC Attachment identifier"
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "ipv6_support" {
  description = "Whether IPv6 support is enabled."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.ipv6_support
}

output "subnet_ids" {
  description = "Identifiers of EC2 Subnets."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.subnet_ids
}

output "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.transit_gateway_id
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway VPC Attachment"
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.tags
}

output "vpc_id" {
  description = "Identifier of EC2 VPC."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.vpc_id
}

output "vpc_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 VPC."
  value       = data.aws_ec2_transit_gateway_vpc_attachment.this.vpc_owner_id
}