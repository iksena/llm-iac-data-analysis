output "arn" {
  description = "ARN of the Default Network ACL"
  value       = aws_default_network_acl.this.arn
}

output "id" {
  description = "ID of the Default Network ACL"
  value       = aws_default_network_acl.this.id
}

output "owner_id" {
  description = "ID of the AWS account that owns the Default Network ACL"
  value       = aws_default_network_acl.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_default_network_acl.this.tags_all
}

output "vpc_id" {
  description = "ID of the associated VPC"
  value       = aws_default_network_acl.this.vpc_id
}