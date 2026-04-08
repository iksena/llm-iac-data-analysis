output "arn" {
  description = "The cache policy ARN."
  value       = aws_cloudfront_cache_policy.this.arn
}

output "etag" {
  description = "Current version of the cache policy."
  value       = aws_cloudfront_cache_policy.this.etag
}

output "id" {
  description = "Identifier for the cache policy."
  value       = aws_cloudfront_cache_policy.this.id
}