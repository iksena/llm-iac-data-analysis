output "id" {
  description = "ID of the resolver rule"
  value       = data.aws_route53_resolver_rule.this.id
}

output "arn" {
  description = "ARN (Amazon Resource Name) for the resolver rule"
  value       = data.aws_route53_resolver_rule.this.arn
}

output "owner_id" {
  description = "When a rule is shared with another AWS account, the account ID of the account that the rule is shared with"
  value       = data.aws_route53_resolver_rule.this.owner_id
}

output "share_status" {
  description = "Whether the rules is shared and, if so, whether the current account is sharing the rule with another account, or another account is sharing the rule with the current account"
  value       = data.aws_route53_resolver_rule.this.share_status
}

output "tags" {
  description = "Map of tags assigned to the resolver rule"
  value       = data.aws_route53_resolver_rule.this.tags
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_route53_resolver_rule.this.region
}

output "domain_name" {
  description = "Domain name the desired resolver rule forwards DNS queries for"
  value       = data.aws_route53_resolver_rule.this.domain_name
}

output "name" {
  description = "Friendly name of the desired resolver rule"
  value       = data.aws_route53_resolver_rule.this.name
}

output "resolver_endpoint_id" {
  description = "ID of the outbound resolver endpoint of the desired resolver rule"
  value       = data.aws_route53_resolver_rule.this.resolver_endpoint_id
}

output "resolver_rule_id" {
  description = "ID of the desired resolver rule"
  value       = data.aws_route53_resolver_rule.this.resolver_rule_id
}

output "rule_type" {
  description = "Rule type of the desired resolver rule"
  value       = data.aws_route53_resolver_rule.this.rule_type
}