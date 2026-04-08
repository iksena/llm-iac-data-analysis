output "id" {
  description = "The name of the subnet group."
  value       = aws_dax_subnet_group.this.id
}

output "vpc_id" {
  description = "VPC ID of the subnet group."
  value       = aws_dax_subnet_group.this.vpc_id
}