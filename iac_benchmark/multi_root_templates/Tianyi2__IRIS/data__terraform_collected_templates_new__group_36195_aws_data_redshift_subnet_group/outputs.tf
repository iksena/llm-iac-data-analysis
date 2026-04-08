output "arn" {
  description = "ARN of the Redshift Subnet Group name."
  value       = data.aws_redshift_subnet_group.this.arn
}

output "description" {
  description = "Description of the Redshift Subnet group."
  value       = data.aws_redshift_subnet_group.this.description
}

output "id" {
  description = "Redshift Subnet group Name."
  value       = data.aws_redshift_subnet_group.this.id
}

output "subnet_ids" {
  description = "An array of VPC subnet IDs."
  value       = data.aws_redshift_subnet_group.this.subnet_ids
}

output "tags" {
  description = "Tags associated to the Subnet Group"
  value       = data.aws_redshift_subnet_group.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_redshift_subnet_group.this.region
}

output "name" {
  description = "Name of the cluster subnet group."
  value       = data.aws_redshift_subnet_group.this.name
}