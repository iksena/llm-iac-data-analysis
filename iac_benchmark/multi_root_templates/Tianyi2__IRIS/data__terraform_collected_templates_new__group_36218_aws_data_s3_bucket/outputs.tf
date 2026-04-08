output "id" {
  description = "Name of the bucket."
  value       = data.aws_s3_bucket.this.id
}

output "arn" {
  description = "ARN of the bucket. Will be of format `arn:aws:s3:::bucketname`."
  value       = data.aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name. Will be of format `bucketname.s3.amazonaws.com`."
  value       = data.aws_s3_bucket.this.bucket_domain_name
}

output "bucket_region" {
  description = "AWS region this bucket resides in."
  value       = data.aws_s3_bucket.this.bucket_region
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name."
  value       = data.aws_s3_bucket.this.bucket_regional_domain_name
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = data.aws_s3_bucket.this.hosted_zone_id
}

output "website_endpoint" {
  description = "Website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = data.aws_s3_bucket.this.website_endpoint
}

output "website_domain" {
  description = "Domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value       = data.aws_s3_bucket.this.website_domain
}