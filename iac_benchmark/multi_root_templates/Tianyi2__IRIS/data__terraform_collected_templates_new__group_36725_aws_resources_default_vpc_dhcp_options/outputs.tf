output "id" {
  description = "The ID of the DHCP Options Set"
  value       = aws_default_vpc_dhcp_options.this.id
}

output "arn" {
  description = "The ARN of the DHCP Options Set"
  value       = aws_default_vpc_dhcp_options.this.arn
}

output "netbios_name_servers" {
  description = "List of NETBIOS name servers"
  value       = aws_default_vpc_dhcp_options.this.netbios_name_servers
}

output "netbios_node_type" {
  description = "The NetBIOS node type"
  value       = aws_default_vpc_dhcp_options.this.netbios_node_type
}

output "owner_id" {
  description = "The ID of the AWS account that owns the DHCP options set"
  value       = aws_default_vpc_dhcp_options.this.owner_id
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_default_vpc_dhcp_options.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_default_vpc_dhcp_options.this.tags_all
}