output "arn" {
  description = "The Amazon Resource Name (ARN) of the security group rule."
  value       = data.aws_vpc_security_group_rule.this.arn
}

output "cidr_ipv4" {
  description = "The destination IPv4 CIDR range."
  value       = data.aws_vpc_security_group_rule.this.cidr_ipv4
}

output "cidr_ipv6" {
  description = "The destination IPv6 CIDR range."
  value       = data.aws_vpc_security_group_rule.this.cidr_ipv6
}

output "description" {
  description = "The security group rule description."
  value       = data.aws_vpc_security_group_rule.this.description
}

output "from_port" {
  description = "The start of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 type."
  value       = data.aws_vpc_security_group_rule.this.from_port
}

output "is_egress" {
  description = "Indicates whether the security group rule is an outbound rule."
  value       = data.aws_vpc_security_group_rule.this.is_egress
}

output "ip_protocol" {
  description = "The IP protocol name or number. Use -1 to specify all protocols."
  value       = data.aws_vpc_security_group_rule.this.ip_protocol
}

output "prefix_list_id" {
  description = "The ID of the destination prefix list."
  value       = data.aws_vpc_security_group_rule.this.prefix_list_id
}

output "referenced_security_group_id" {
  description = "The destination security group that is referenced in the rule."
  value       = data.aws_vpc_security_group_rule.this.referenced_security_group_id
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = data.aws_vpc_security_group_rule.this.security_group_id
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = data.aws_vpc_security_group_rule.this.tags
}

output "to_port" {
  description = "The end of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 code."
  value       = data.aws_vpc_security_group_rule.this.to_port
}