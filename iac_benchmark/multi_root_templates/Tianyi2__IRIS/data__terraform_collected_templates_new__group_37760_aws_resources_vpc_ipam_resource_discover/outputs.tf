output "arn" {
  description = "The Amazon Resource Name (ARN) of IPAM Resource Discovery Association."
  value       = aws_vpc_ipam_resource_discovery_association.this.arn
}

output "id" {
  description = "The ID of the IPAM Resource Discovery Association."
  value       = aws_vpc_ipam_resource_discovery_association.this.id
}

output "owner_id" {
  description = "The account ID for the account that manages the Resource Discovery."
  value       = aws_vpc_ipam_resource_discovery_association.this.owner_id
}

output "ipam_arn" {
  description = "The Amazon Resource Name (ARN) of the IPAM."
  value       = aws_vpc_ipam_resource_discovery_association.this.ipam_arn
}

output "ipam_region" {
  description = "The home region of the IPAM."
  value       = aws_vpc_ipam_resource_discovery_association.this.ipam_region
}

output "is_default" {
  description = "A boolean to identify if the Resource Discovery is the accounts default resource discovery."
  value       = aws_vpc_ipam_resource_discovery_association.this.is_default
}

output "state" {
  description = "The lifecycle state of the association when you associate or disassociate a resource discovery."
  value       = aws_vpc_ipam_resource_discovery_association.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_ipam_resource_discovery_association.this.tags_all
}