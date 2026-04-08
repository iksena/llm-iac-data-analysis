output "partition" {
  description = "Partition that the resource is in"
  value       = data.aws_arn.this.partition
}

output "service" {
  description = "The service namespace that identifies the AWS product"
  value       = data.aws_arn.this.service
}

output "region" {
  description = "Region the resource resides in"
  value       = data.aws_arn.this.region
}

output "account" {
  description = "The ID of the AWS account that owns the resource, without the hyphens"
  value       = data.aws_arn.this.account
}

output "resource" {
  description = "Content of this part of the ARN varies by service"
  value       = data.aws_arn.this.resource
}