output "arn" {
  description = "Amazon Resource Name (ARN) of IPAM"
  value       = aws_vpc_ipam_pool.this.arn
}

output "id" {
  description = "The ID of the IPAM"
  value       = aws_vpc_ipam_pool.this.id
}

output "state" {
  description = "The ID of the IPAM"
  value       = aws_vpc_ipam_pool.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_ipam_pool.this.tags_all
}