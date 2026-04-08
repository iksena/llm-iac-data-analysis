output "arn" {
  description = "ARN of the prefix list."
  value       = aws_ec2_managed_prefix_list.this.arn
}

output "id" {
  description = "ID of the prefix list."
  value       = aws_ec2_managed_prefix_list.this.id
}

output "owner_id" {
  description = "ID of the AWS account that owns this prefix list."
  value       = aws_ec2_managed_prefix_list.this.owner_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_managed_prefix_list.this.tags_all
}

output "version" {
  description = "Latest version of this prefix list."
  value       = aws_ec2_managed_prefix_list.this.version
}