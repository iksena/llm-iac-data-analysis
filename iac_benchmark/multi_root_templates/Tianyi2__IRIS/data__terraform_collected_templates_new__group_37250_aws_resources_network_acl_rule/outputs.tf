output "id" {
  description = "The ID of the network ACL Rule"
  value       = aws_network_acl_rule.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_network_acl_rule.this.region
}

output "network_acl_id" {
  description = "The ID of the network ACL"
  value       = aws_network_acl_rule.this.network_acl_id
}

output "rule_number" {
  description = "The rule number for the entry"
  value       = aws_network_acl_rule.this.rule_number
}

output "egress" {
  description = "Whether this is an egress rule"
  value       = aws_network_acl_rule.this.egress
}

output "protocol" {
  description = "The protocol"
  value       = aws_network_acl_rule.this.protocol
}

output "rule_action" {
  description = "Whether to allow or deny the traffic that matches the rule"
  value       = aws_network_acl_rule.this.rule_action
}

output "cidr_block" {
  description = "The network range to allow or deny, in CIDR notation"
  value       = aws_network_acl_rule.this.cidr_block
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block to allow or deny"
  value       = aws_network_acl_rule.this.ipv6_cidr_block
}

output "from_port" {
  description = "The from port to match"
  value       = aws_network_acl_rule.this.from_port
}

output "to_port" {
  description = "The to port to match"
  value       = aws_network_acl_rule.this.to_port
}

output "icmp_type" {
  description = "ICMP protocol: The ICMP type"
  value       = aws_network_acl_rule.this.icmp_type
}

output "icmp_code" {
  description = "ICMP protocol: The ICMP code"
  value       = aws_network_acl_rule.this.icmp_code
}