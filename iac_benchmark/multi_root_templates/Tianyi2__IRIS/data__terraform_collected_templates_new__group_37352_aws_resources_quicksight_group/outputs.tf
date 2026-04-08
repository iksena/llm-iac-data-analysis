output "arn" {
  description = "Amazon Resource Name (ARN) of group"
  value       = aws_quicksight_group.this.arn
}

output "aws_account_id" {
  description = "AWS account ID"
  value       = aws_quicksight_group.this.aws_account_id
}

output "description" {
  description = "Description for the group"
  value       = aws_quicksight_group.this.description
}

output "group_name" {
  description = "Name for the group"
  value       = aws_quicksight_group.this.group_name
}

output "namespace" {
  description = "The namespace"
  value       = aws_quicksight_group.this.namespace
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_quicksight_group.this.region
}