output "arn" {
  description = "The Amazon Resource Name (ARN) of the security group rule."
  value       = aws_vpc_security_group_egress_rule.this.arn
}

output "security_group_rule_id" {
  description = "The ID of the security group rule."
  value       = aws_vpc_security_group_egress_rule.this.security_group_rule_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_security_group_egress_rule.this.tags_all
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_vpc_security_group_egress_rule.this.region
}

output "cidr_ipv4" {
  description = "The destination IPv4 CIDR range."
  value       = aws_vpc_security_group_egress_rule.this.cidr_ipv4
}

output "cidr_ipv6" {
  description = "The destination IPv6 CIDR range."
  value       = aws_vpc_security_group_egress_rule.this.cidr_ipv6
}

output "description" {
  description = "The security group rule description."
  value       = aws_vpc_security_group_egress_rule.this.description
}

output "from_port" {
  description = "The start of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 type."
  value       = aws_vpc_security_group_egress_rule.this.from_port
}

output "ip_protocol" {
  description = "The IP protocol name or number."
  value       = aws_vpc_security_group_egress_rule.this.ip_protocol
}

output "prefix_list_id" {
  description = "The ID of the destination prefix list."
  value       = aws_vpc_security_group_egress_rule.this.prefix_list_id
}

output "referenced_security_group_id" {
  description = "The destination security group that is referenced in the rule."
  value       = aws_vpc_security_group_egress_rule.this.referenced_security_group_id
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = aws_vpc_security_group_egress_rule.this.security_group_id
}

output "tags" {
  description = "A map of tags to assign to the resource."
  value       = aws_vpc_security_group_egress_rule.this.tags
}

output "to_port" {
  description = "The end of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 code."
  value       = aws_vpc_security_group_egress_rule.this.to_port
}