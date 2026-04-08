output "arn" {
  description = "The Amazon Resource Name (ARN) of the firewall rule group association."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.arn
}

output "creation_time" {
  description = "The date and time that the association was created, in Unix time format and Coordinated Universal Time (UTC)."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.creation_time
}

output "creator_request_id" {
  description = "A unique string defined by you to identify the request."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.creator_request_id
}

output "firewall_rule_group_id" {
  description = "The unique identifier of the firewall rule group."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.firewall_rule_group_id
}

output "managed_owner_name" {
  description = "The owner of the association, used only for associations that are not managed by you."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.managed_owner_name
}

output "modification_time" {
  description = "The date and time that the association was last modified, in Unix time format and Coordinated Universal Time (UTC)."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.modification_time
}

output "mutation_protection" {
  description = "If enabled, this setting disallows modification or removal of the association, to help prevent against accidentally altering DNS firewall protections."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.mutation_protection
}

output "name" {
  description = "The name of the association."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.name
}

output "priority" {
  description = "The setting that determines the processing order of the rule group among the rule groups that are associated with a single VPC."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.priority
}

output "status" {
  description = "The current status of the association."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.status
}

output "status_message" {
  description = "Additional information about the status of the response, if available."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.status_message
}

output "vpc_id" {
  description = "The unique identifier of the VPC that is associated with the rule group."
  value       = data.aws_route53_resolver_firewall_rule_group_association.this.vpc_id
}