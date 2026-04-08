output "firewall_fail_open" {
  description = "Determines how DNS Firewall operates during failures, for example when all traffic that is sent to DNS Firewall fails to receive a reply."
  value       = data.aws_route53_resolver_firewall_config.this.firewall_fail_open
}

output "id" {
  description = "The ID of the firewall configuration."
  value       = data.aws_route53_resolver_firewall_config.this.id
}

output "owner_id" {
  description = "The Amazon Web Services account ID of the owner of the VPC that this firewall configuration applies to."
  value       = data.aws_route53_resolver_firewall_config.this.owner_id
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_route53_resolver_firewall_config.this.region
}

output "resource_id" {
  description = "The ID of the VPC from Amazon VPC that the configuration is for."
  value       = data.aws_route53_resolver_firewall_config.this.resource_id
}