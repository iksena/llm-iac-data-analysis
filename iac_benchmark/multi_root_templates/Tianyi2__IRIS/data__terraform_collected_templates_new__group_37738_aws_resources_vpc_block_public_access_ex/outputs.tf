output "id" {
  description = "The ID of the VPC Block Public Access Exclusion."
  value       = aws_vpc_block_public_access_exclusion.this.id
}

output "resource_arn" {
  description = "The Amazon Resource Name (ARN) the excluded resource."
  value       = aws_vpc_block_public_access_exclusion.this.resource_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_block_public_access_exclusion.this.tags_all
}