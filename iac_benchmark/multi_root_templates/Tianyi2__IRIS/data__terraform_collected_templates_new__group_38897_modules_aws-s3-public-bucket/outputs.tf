output "domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}
