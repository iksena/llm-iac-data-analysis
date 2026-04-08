output "alias" {
  description = "The alias for the Multi-Region Access Point."
  value       = data.aws_s3control_multi_region_access_point.this.alias
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the Multi-Region Access Point."
  value       = data.aws_s3control_multi_region_access_point.this.arn
}

output "created_at" {
  description = "Timestamp when the resource has been created."
  value       = data.aws_s3control_multi_region_access_point.this.created_at
}

output "domain_name" {
  description = "The DNS domain name of the S3 Multi-Region Access Point in the format _`alias`_.accesspoint.s3-global.amazonaws.com."
  value       = data.aws_s3control_multi_region_access_point.this.domain_name
}

output "public_access_block" {
  description = "Public Access Block of the Multi-Region Access Point."
  value       = data.aws_s3control_multi_region_access_point.this.public_access_block
}

output "regions" {
  description = "A collection of the regions and buckets associated with the Multi-Region Access Point."
  value       = data.aws_s3control_multi_region_access_point.this.regions
}

output "status" {
  description = "The current status of the Multi-Region Access Point."
  value       = data.aws_s3control_multi_region_access_point.this.status
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_s3control_multi_region_access_point.this.region
}

output "account_id" {
  description = "The AWS account ID of the S3 Multi-Region Access Point."
  value       = data.aws_s3control_multi_region_access_point.this.account_id
}

output "name" {
  description = "The name of the Multi-Region Access Point."
  value       = data.aws_s3control_multi_region_access_point.this.name
}