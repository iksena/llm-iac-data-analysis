output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_dms_replication_subnet_group.this.region
}

output "replication_subnet_group_id" {
  description = "Name for the replication subnet group."
  value       = data.aws_dms_replication_subnet_group.this.replication_subnet_group_id
}

output "replication_subnet_group_description" {
  description = "Description for the subnet group."
  value       = data.aws_dms_replication_subnet_group.this.replication_subnet_group_description
}

output "subnet_ids" {
  description = "List of at least 2 EC2 subnet IDs for the subnet group."
  value       = data.aws_dms_replication_subnet_group.this.subnet_ids
}

output "vpc_id" {
  description = "The ID of the VPC the subnet group is in."
  value       = data.aws_dms_replication_subnet_group.this.vpc_id
}