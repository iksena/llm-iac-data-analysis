output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Subnet group name"
  value       = aws_redshift_subnet_group.this.arn
}

output "id" {
  description = "The Redshift Subnet group ID."
  value       = aws_redshift_subnet_group.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshift_subnet_group.this.tags_all
}