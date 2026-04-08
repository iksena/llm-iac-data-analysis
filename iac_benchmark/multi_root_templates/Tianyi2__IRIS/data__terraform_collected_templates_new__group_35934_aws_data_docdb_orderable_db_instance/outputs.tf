output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_docdb_orderable_db_instance.this.region
}

output "engine" {
  description = "DB engine."
  value       = data.aws_docdb_orderable_db_instance.this.engine
}

output "engine_version" {
  description = "Version of the DB engine."
  value       = data.aws_docdb_orderable_db_instance.this.engine_version
}

output "instance_class" {
  description = "DB instance class."
  value       = data.aws_docdb_orderable_db_instance.this.instance_class
}

output "license_model" {
  description = "License model."
  value       = data.aws_docdb_orderable_db_instance.this.license_model
}

output "preferred_instance_classes" {
  description = "Ordered list of preferred DocumentDB DB instance classes."
  value       = data.aws_docdb_orderable_db_instance.this.preferred_instance_classes
}

output "vpc" {
  description = "Enable to show only VPC."
  value       = data.aws_docdb_orderable_db_instance.this.vpc
}

output "availability_zones" {
  description = "Availability zones where the instance is available."
  value       = data.aws_docdb_orderable_db_instance.this.availability_zones
}