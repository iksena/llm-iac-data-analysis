output "group_name" {
  description = "The name of the group that you want to match."
  value       = data.aws_quicksight_group.this.group_name
}

output "aws_account_id" {
  description = "AWS account ID."
  value       = data.aws_quicksight_group.this.aws_account_id
}

output "namespace" {
  description = "QuickSight namespace."
  value       = data.aws_quicksight_group.this.namespace
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_quicksight_group.this.region
}

output "arn" {
  description = "The Amazon Resource Name (ARN) for the group."
  value       = data.aws_quicksight_group.this.arn
}

output "description" {
  description = "The group description."
  value       = data.aws_quicksight_group.this.description
}

output "principal_id" {
  description = "The principal ID of the group."
  value       = data.aws_quicksight_group.this.principal_id
}