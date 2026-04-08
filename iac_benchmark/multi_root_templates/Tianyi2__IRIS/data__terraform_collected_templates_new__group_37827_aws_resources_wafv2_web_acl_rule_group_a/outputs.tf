output "rule_name" {
  description = "Name of the rule created in the Web ACL that references the rule group"
  value       = aws_wafv2_web_acl_rule_group_association.this.rule_name
}

output "priority" {
  description = "Priority of the rule within the Web ACL"
  value       = aws_wafv2_web_acl_rule_group_association.this.priority
}

output "web_acl_arn" {
  description = "ARN of the Web ACL associated with the Rule Group"
  value       = aws_wafv2_web_acl_rule_group_association.this.web_acl_arn
}

output "override_action" {
  description = "Override action for the rule group"
  value       = aws_wafv2_web_acl_rule_group_association.this.override_action
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_wafv2_web_acl_rule_group_association.this.region
}

output "managed_rule_group" {
  description = "Managed Rule Group configuration"
  value       = aws_wafv2_web_acl_rule_group_association.this.managed_rule_group
}

output "rule_group_reference" {
  description = "Custom Rule Group reference configuration"
  value       = aws_wafv2_web_acl_rule_group_association.this.rule_group_reference
}