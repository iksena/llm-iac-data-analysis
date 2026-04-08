output "id" {
  description = "AWS Region."
  value       = data.aws_eips.this.id
}

output "allocation_ids" {
  description = "List of all the allocation IDs for address for use with EC2-VPC."
  value       = data.aws_eips.this.allocation_ids
}

output "public_ips" {
  description = "List of all the Elastic IP addresses."
  value       = data.aws_eips.this.public_ips
}