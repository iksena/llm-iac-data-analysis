output "account_id" {
  description = "AWS account ID for the account that owns the specified access point"
  value       = data.aws_s3_access_point.this.account_id
}

output "alias" {
  description = "Access point alias"
  value       = data.aws_s3_access_point.this.alias
}

output "arn" {
  description = "Access point ARN"
  value       = data.aws_s3_access_point.this.arn
}

output "bucket" {
  description = "Name of the bucket associated with the access point"
  value       = data.aws_s3_access_point.this.bucket
}

output "bucket_account_id" {
  description = "AWS account ID associated with the S3 bucket associated with the access point"
  value       = data.aws_s3_access_point.this.bucket_account_id
}

output "data_source_id" {
  description = "Unique identifier for the data source of the access point"
  value       = data.aws_s3_access_point.this.data_source_id
}

output "data_source_type" {
  description = "Type of the data source that the access point is attached to"
  value       = data.aws_s3_access_point.this.data_source_type
}

output "endpoints" {
  description = "VPC endpoint for the access point"
  value       = data.aws_s3_access_point.this.endpoints
}

output "name" {
  description = "Name of the access point"
  value       = data.aws_s3_access_point.this.name
}

output "network_origin" {
  description = "Indicates whether the access point allows access from the public Internet"
  value       = data.aws_s3_access_point.this.network_origin
}

output "public_access_block_configuration" {
  description = "PublicAccessBlock configuration for the access point"
  value       = data.aws_s3_access_point.this.public_access_block_configuration
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_s3_access_point.this.region
}

output "tags" {
  description = "Tags assigned to the access point"
  value       = data.aws_s3_access_point.this.tags
}

output "vpc_configuration" {
  description = "VPC configuration for the access point"
  value       = data.aws_s3_access_point.this.vpc_configuration
}