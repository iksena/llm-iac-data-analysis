output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_security_group.this.region
}

output "id" {
  description = "Id of the specific security group"
  value       = data.aws_security_group.this.id
}

output "name" {
  description = "Name of the security group"
  value       = data.aws_security_group.this.name
}

output "tags" {
  description = "Map of tags assigned to the security group"
  value       = data.aws_security_group.this.tags
}

output "vpc_id" {
  description = "Id of the VPC that the security group belongs to"
  value       = data.aws_security_group.this.vpc_id
}

output "description" {
  description = "Description of the security group"
  value       = data.aws_security_group.this.description
}

output "arn" {
  description = "Computed ARN of the security group"
  value       = data.aws_security_group.this.arn
}