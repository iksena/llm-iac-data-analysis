output "alias" {
  description = "Alias of the S3 Access Point."
  value       = aws_s3_access_point.this.alias
}

output "arn" {
  description = "ARN of the S3 Access Point."
  value       = aws_s3_access_point.this.arn
}

output "domain_name" {
  description = "DNS domain name of the S3 Access Point in the format name-account_id.s3-accesspoint.region.amazonaws.com."
  value       = aws_s3_access_point.this.domain_name
}

output "endpoints" {
  description = "VPC endpoints for the S3 Access Point."
  value       = aws_s3_access_point.this.endpoints
}

output "has_public_access_policy" {
  description = "Indicates whether this access point currently has a policy that allows public access."
  value       = aws_s3_access_point.this.has_public_access_policy
}

output "id" {
  description = "For Access Point of an AWS Partition S3 Bucket, the AWS account ID and access point name separated by a colon (:). For S3 on Outposts Bucket, the ARN of the Access Point."
  value       = aws_s3_access_point.this.id
}

output "network_origin" {
  description = "Indicates whether this access point allows access from the public Internet. Values are VPC (the access point doesn't allow access from the public Internet) and Internet (the access point allows access from the public Internet, subject to the access point and bucket access policies)."
  value       = aws_s3_access_point.this.network_origin
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3_access_point.this.tags_all
}