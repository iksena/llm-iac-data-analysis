output "ids" {
  description = "List of all the security group rule IDs found."
  value       = data.aws_vpc_security_group_rules.this.ids
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_vpc_security_group_rules.this.region
}

output "filter" {
  description = "Custom filter blocks applied to the security group rules query."
  value       = var.filter
}

output "tags" {
  description = "Map of tags used to filter security group rules."
  value       = data.aws_vpc_security_group_rules.this.tags
}