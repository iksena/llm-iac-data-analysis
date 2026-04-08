output "alias" {
  description = "The alias for the Multi-Region Access Point."
  value       = aws_s3control_multi_region_access_point.this.alias
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the Multi-Region Access Point."
  value       = aws_s3control_multi_region_access_point.this.arn
}

output "domain_name" {
  description = "The DNS domain name of the S3 Multi-Region Access Point in the format _alias_.accesspoint.s3-global.amazonaws.com."
  value       = aws_s3control_multi_region_access_point.this.domain_name
}

output "id" {
  description = "The AWS account ID and access point name separated by a colon (:)."
  value       = aws_s3control_multi_region_access_point.this.id
}

output "status" {
  description = "The current status of the Multi-Region Access Point. One of: READY, INCONSISTENT_ACROSS_REGIONS, CREATING, PARTIALLY_CREATED, PARTIALLY_DELETED, DELETING."
  value       = aws_s3control_multi_region_access_point.this.status
}