output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_wafv2_rule_group.this.region
}

output "name" {
  description = "Name of the WAFv2 Rule Group."
  value       = data.aws_wafv2_rule_group.this.name
}

output "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application."
  value       = data.aws_wafv2_rule_group.this.scope
}

output "arn" {
  description = "ARN of the entity."
  value       = data.aws_wafv2_rule_group.this.arn
}

output "description" {
  description = "Description of the rule group that helps with identification."
  value       = data.aws_wafv2_rule_group.this.description
}

output "id" {
  description = "Unique identifier of the rule group."
  value       = data.aws_wafv2_rule_group.this.id
}