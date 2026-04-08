output "arn" {
  description = "The ARN (Amazon Resource Name) of the rule group."
  value       = data.aws_route53_resolver_firewall_rule_group.this.arn
}

output "creation_time" {
  description = "The date and time that the rule group was created, in Unix time format and Coordinated Universal Time (UTC)."
  value       = data.aws_route53_resolver_firewall_rule_group.this.creation_time
}

output "creator_request_id" {
  description = "A unique string defined by you to identify the request."
  value       = data.aws_route53_resolver_firewall_rule_group.this.creator_request_id
}

output "name" {
  description = "The name of the rule group."
  value       = data.aws_route53_resolver_firewall_rule_group.this.name
}

output "modification_time" {
  description = "The date and time that the rule group was last modified, in Unix time format and Coordinated Universal Time (UTC)."
  value       = data.aws_route53_resolver_firewall_rule_group.this.modification_time
}

output "owner_id" {
  description = "The Amazon Web Services account ID for the account that created the rule group."
  value       = data.aws_route53_resolver_firewall_rule_group.this.owner_id
}

output "rule_count" {
  description = "The number of rules in the rule group."
  value       = data.aws_route53_resolver_firewall_rule_group.this.rule_count
}

output "share_status" {
  description = "Whether the rule group is shared with other Amazon Web Services accounts, or was shared with the current account by another Amazon Web Services account."
  value       = data.aws_route53_resolver_firewall_rule_group.this.share_status
}

output "status" {
  description = "The status of the rule group."
  value       = data.aws_route53_resolver_firewall_rule_group.this.status
}

output "status_message" {
  description = "Additional information about the status of the rule group, if available."
  value       = data.aws_route53_resolver_firewall_rule_group.this.status_message
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_route53_resolver_firewall_rule_group.this.region
}

output "firewall_rule_group_id" {
  description = "The ID of the rule group."
  value       = data.aws_route53_resolver_firewall_rule_group.this.firewall_rule_group_id
}