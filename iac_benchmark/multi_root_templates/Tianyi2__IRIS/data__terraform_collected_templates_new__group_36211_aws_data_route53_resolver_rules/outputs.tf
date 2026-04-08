output "id" {
  description = "AWS Region."
  value       = data.aws_route53_resolver_rules.this.id
}

output "resolver_rule_ids" {
  description = "IDs of the matched resolver rules."
  value       = data.aws_route53_resolver_rules.this.resolver_rule_ids
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_route53_resolver_rules.this.region
}

output "name_regex" {
  description = "Regex string to filter resolver rule names."
  value       = data.aws_route53_resolver_rules.this.name_regex
}

output "owner_id" {
  description = "When the desired resolver rules are shared with another AWS account, the account ID of the account that the rules are shared with."
  value       = data.aws_route53_resolver_rules.this.owner_id
}

output "resolver_endpoint_id" {
  description = "ID of the outbound resolver endpoint for the desired resolver rules."
  value       = data.aws_route53_resolver_rules.this.resolver_endpoint_id
}

output "rule_type" {
  description = "Rule type of the desired resolver rules."
  value       = data.aws_route53_resolver_rules.this.rule_type
}

output "share_status" {
  description = "Whether the desired resolver rules are shared and, if so, whether the current account is sharing the rules with another account, or another account is sharing the rules with the current account."
  value       = data.aws_route53_resolver_rules.this.share_status
}