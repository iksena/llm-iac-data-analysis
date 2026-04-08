output "arn" {
  description = "The Amazon Resource Name (ARN) of the scope."
  value       = aws_vpc_ipam_scope.this.arn
}

output "id" {
  description = "The ID of the IPAM Scope."
  value       = aws_vpc_ipam_scope.this.id
}

output "ipam_arn" {
  description = "The ARN of the IPAM for which you're creating this scope."
  value       = aws_vpc_ipam_scope.this.ipam_arn
}

output "is_default" {
  description = "Defines if the scope is the default scope or not."
  value       = aws_vpc_ipam_scope.this.is_default
}

output "pool_count" {
  description = "The number of pools in the scope."
  value       = aws_vpc_ipam_scope.this.pool_count
}

