output "id" {
  description = "The ID of the VPC CIDR association."
  value       = aws_vpc_ipv6_cidr_block_association.this.id
}

output "ip_source" {
  description = "The source that allocated the IP address space. Values: amazon, byoip, none."
  value       = aws_vpc_ipv6_cidr_block_association.this.ip_source
}

output "ipv6_address_attribute" {
  description = "Public IPv6 addresses are those advertised on the internet from AWS. Private IP addresses are not and cannot be advertised on the internet from AWS. Values: public, private."
  value       = aws_vpc_ipv6_cidr_block_association.this.ipv6_address_attribute
}