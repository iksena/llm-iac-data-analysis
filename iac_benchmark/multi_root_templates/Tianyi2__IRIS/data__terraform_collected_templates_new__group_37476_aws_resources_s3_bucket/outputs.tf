output "id" {
  description = "Name of the bucket."
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_region" {
  description = "AWS region this bucket resides in."
  value       = aws_s3_bucket.this.bucket_region
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID for this bucket's region."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3_bucket.this.tags_all
}