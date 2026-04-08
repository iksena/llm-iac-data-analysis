output "id" {
  description = "ID of the security group rule"
  value       = aws_security_group_rule.this.id
}

output "security_group_rule_id" {
  description = "If the aws_security_group_rule resource has a single source or destination then this is the AWS Security Group Rule resource ID. Otherwise it is empty"
  value       = aws_security_group_rule.this.security_group_rule_id
}