output "arn" {
  description = "The Amazon Resource Name (ARN) of the firewall domain list."
  value       = data.aws_route53_resolver_firewall_domain_list.this.arn
}

output "creation_time" {
  description = "The date and time that the domain list was created, in Unix time format and Coordinated Universal Time (UTC)."
  value       = data.aws_route53_resolver_firewall_domain_list.this.creation_time
}

output "creator_request_id" {
  description = "A unique string defined by you to identify the request."
  value       = data.aws_route53_resolver_firewall_domain_list.this.creator_request_id
}

output "domain_count" {
  description = "The number of domain names that are specified in the domain list."
  value       = data.aws_route53_resolver_firewall_domain_list.this.domain_count
}

output "firewall_domain_list_id" {
  description = "The ID of the domain list."
  value       = data.aws_route53_resolver_firewall_domain_list.this.firewall_domain_list_id
}

output "name" {
  description = "The name of the domain list."
  value       = data.aws_route53_resolver_firewall_domain_list.this.name
}

output "managed_owner_name" {
  description = "The owner of the list, used only for lists that are not managed by you."
  value       = data.aws_route53_resolver_firewall_domain_list.this.managed_owner_name
}

output "modification_time" {
  description = "The date and time that the domain list was last modified, in Unix time format and Coordinated Universal Time (UTC)."
  value       = data.aws_route53_resolver_firewall_domain_list.this.modification_time
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_route53_resolver_firewall_domain_list.this.region
}

output "status" {
  description = "The status of the domain list."
  value       = data.aws_route53_resolver_firewall_domain_list.this.status
}

output "status_message" {
  description = "Additional information about the status of the list, if available."
  value       = data.aws_route53_resolver_firewall_domain_list.this.status_message
}