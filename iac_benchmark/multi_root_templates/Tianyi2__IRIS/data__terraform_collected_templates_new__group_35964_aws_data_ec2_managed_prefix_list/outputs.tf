output "id" {
  description = "ID of the selected prefix list"
  value       = data.aws_ec2_managed_prefix_list.this.id
}

output "arn" {
  description = "ARN of the selected prefix list"
  value       = data.aws_ec2_managed_prefix_list.this.arn
}

output "name" {
  description = "Name of the selected prefix list"
  value       = data.aws_ec2_managed_prefix_list.this.name
}

output "entries" {
  description = "Set of entries in this prefix list. Each entry is an object with cidr and description"
  value       = data.aws_ec2_managed_prefix_list.this.entries
}

output "owner_id" {
  description = "Account ID of the owner of a customer-managed prefix list, or AWS otherwise"
  value       = data.aws_ec2_managed_prefix_list.this.owner_id
}

output "address_family" {
  description = "Address family of the prefix list. Valid values are IPv4 and IPv6"
  value       = data.aws_ec2_managed_prefix_list.this.address_family
}

output "max_entries" {
  description = "When then prefix list is managed, the maximum number of entries it supports, or null otherwise"
  value       = data.aws_ec2_managed_prefix_list.this.max_entries
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = data.aws_ec2_managed_prefix_list.this.tags
}