output "arn" {
  description = "ARN of the resource share"
  value       = data.aws_ram_resource_share.this.arn
}

output "id" {
  description = "ARN of the resource share"
  value       = data.aws_ram_resource_share.this.id
}

output "owning_account_id" {
  description = "ID of the AWS account that owns the resource share"
  value       = data.aws_ram_resource_share.this.owning_account_id
}

output "resource_arns" {
  description = "A list of resource ARNs associated with the resource share"
  value       = data.aws_ram_resource_share.this.resource_arns
}

output "status" {
  description = "Status of the resource share"
  value       = data.aws_ram_resource_share.this.status
}

output "tags" {
  description = "Tags attached to the resource share"
  value       = data.aws_ram_resource_share.this.tags
}