output "arn" {
  description = "Amazon Resource Name (ARN) of IPAM Resource Discovery"
  value       = aws_vpc_ipam_resource_discovery.this.arn
}

output "id" {
  description = "The ID of the IPAM Resource Discovery"
  value       = aws_vpc_ipam_resource_discovery.this.id
}

output "is_default" {
  description = "A boolean to identify if the Resource Discovery is the accounts default resource discovery"
  value       = aws_vpc_ipam_resource_discovery.this.is_default
}

output "owner_id" {
  description = "The account ID for the account that manages the Resource Discovery"
  value       = aws_vpc_ipam_resource_discovery.this.owner_id
}

output "ipam_resource_discovery_region" {
  description = "The home region of the Resource Discovery"
  value       = aws_vpc_ipam_resource_discovery.this.ipam_resource_discovery_region
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpc_ipam_resource_discovery.this.tags_all
}