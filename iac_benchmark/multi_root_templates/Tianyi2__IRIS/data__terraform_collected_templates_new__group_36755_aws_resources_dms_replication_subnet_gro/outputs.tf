output "region" {
  description = "Region where this resource is managed."
  value       = aws_dms_replication_subnet_group.this.region
}

output "replication_subnet_group_description" {
  description = "Description for the subnet group."
  value       = aws_dms_replication_subnet_group.this.replication_subnet_group_description
}

output "replication_subnet_group_id" {
  description = "Name for the replication subnet group."
  value       = aws_dms_replication_subnet_group.this.replication_subnet_group_id
}

output "subnet_ids" {
  description = "List of EC2 subnet IDs for the subnet group."
  value       = aws_dms_replication_subnet_group.this.subnet_ids
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_dms_replication_subnet_group.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dms_replication_subnet_group.this.tags_all
}

output "vpc_id" {
  description = "The ID of the VPC the subnet group is in."
  value       = aws_dms_replication_subnet_group.this.vpc_id
}