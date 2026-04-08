output "id" {
  description = "The ID of the network ACL"
  value       = aws_network_acl.this.id
}

output "arn" {
  description = "The ARN of the network ACL"
  value       = aws_network_acl.this.arn
}

output "owner_id" {
  description = "The ID of the AWS account that owns the network ACL"
  value       = aws_network_acl.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_network_acl.this.tags_all
}