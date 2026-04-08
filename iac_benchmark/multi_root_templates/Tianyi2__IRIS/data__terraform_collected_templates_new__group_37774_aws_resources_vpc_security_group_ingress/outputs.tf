output "arn" {
  description = "The Amazon Resource Name (ARN) of the security group rule."
  value       = aws_vpc_security_group_ingress_rule.this.arn
}

output "security_group_rule_id" {
  description = "The ID of the security group rule."
  value       = aws_vpc_security_group_ingress_rule.this.security_group_rule_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_security_group_ingress_rule.this.tags_all
}