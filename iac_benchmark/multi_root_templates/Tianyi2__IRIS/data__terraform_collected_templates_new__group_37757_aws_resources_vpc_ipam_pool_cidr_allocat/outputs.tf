output "id" {
  description = "The ID of the allocation."
  value       = aws_vpc_ipam_pool_cidr_allocation.this.id
}

output "resource_id" {
  description = "The ID of the resource."
  value       = aws_vpc_ipam_pool_cidr_allocation.this.resource_id
}

output "resource_owner" {
  description = "The owner of the resource."
  value       = aws_vpc_ipam_pool_cidr_allocation.this.resource_owner
}

output "resource_type" {
  description = "The type of the resource."
  value       = aws_vpc_ipam_pool_cidr_allocation.this.resource_type
}