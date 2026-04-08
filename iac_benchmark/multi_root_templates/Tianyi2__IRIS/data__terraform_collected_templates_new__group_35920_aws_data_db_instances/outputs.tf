output "instance_arns" {
  description = "ARNs of the matched RDS instances."
  value       = data.aws_db_instances.this.instance_arns
}

output "instance_identifiers" {
  description = "Identifiers of the matched RDS instances."
  value       = data.aws_db_instances.this.instance_identifiers
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_db_instances.this.region
}

output "filters" {
  description = "Configuration blocks used to filter instances."
  value       = var.filters
}

output "tags" {
  description = "Map of tags used to filter instances."
  value       = data.aws_db_instances.this.tags
}