output "web_acl_arn" {
  value       = aws_wafv2_web_acl.waf.arn
  description = "The ARN of the WebACL."
}

output "web_acl_id" {
  value       = aws_wafv2_web_acl.waf.id
  description = "The ID of the WebACL."
}

output "web_acl_capacity" {
  value       = aws_wafv2_web_acl.waf.capacity
  description = "The capacity of the WebACL."
}

output "waf_association_ids" {
  value       = [for i in aws_wafv2_web_acl_association.waf_association : i.id]
  description = "The IDs of the WAF associations."
}

output "cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.log_group.arn
  description = "The ARN of the CloudWatch Log Group."
}

output "waf_logging_config_log_destination_configs" {
  value       = aws_wafv2_web_acl_logging_configuration.waf_logging_config.log_destination_configs
  description = "The log destination configurations of the WAF logging configuration."
}

output "cloudwatch_log_resource_policy_id" {
  value       = aws_cloudwatch_log_resource_policy.resource_policy.id
  description = "The ID of the CloudWatch log resource policy."
}
