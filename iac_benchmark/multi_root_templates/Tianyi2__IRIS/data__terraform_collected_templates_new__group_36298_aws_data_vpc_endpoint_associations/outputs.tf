output "associations" {
  description = "Associations for the VPC Endpoint."
  value       = data.aws_vpc_endpoint_associations.this.associations
}

output "associated_resource_accessibility" {
  description = "Accessibility of the resource for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.associated_resource_accessibility]
}

output "associated_resource_arn" {
  description = "ARN of the resource for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.associated_resource_arn]
}

output "dns_entry" {
  description = "DNS entries for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.dns_entry]
}

output "private_dns_entry" {
  description = "Private DNS entries for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.private_dns_entry]
}

output "resource_configuration_group_arn" {
  description = "ARN of the Resource Group if the Resource is a member of a group for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.resource_configuration_group_arn]
}

output "service_network_arn" {
  description = "Service Network ARN for each association (applicable for endpoints of type ServiceNetwork)."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.service_network_arn]
}

output "service_network_name" {
  description = "Service Network Name for each association (applicable for endpoints of type ServiceNetwork)."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.service_network_name]
}

output "tags" {
  description = "Tags of each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : association.tags]
}

output "dns_names" {
  description = "DNS names from dns_entry blocks for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : [for dns in association.dns_entry : dns.dns_name]]
}

output "hosted_zone_ids" {
  description = "Hosted zone IDs from dns_entry blocks for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : [for dns in association.dns_entry : dns.hosted_zone_id]]
}

output "private_dns_names" {
  description = "DNS names from private_dns_entry blocks for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : [for dns in association.private_dns_entry : dns.dns_name]]
}

output "private_hosted_zone_ids" {
  description = "Hosted zone IDs from private_dns_entry blocks for each association."
  value       = [for association in data.aws_vpc_endpoint_associations.this.associations : [for dns in association.private_dns_entry : dns.hosted_zone_id]]
}