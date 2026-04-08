output "arn" {
  description = "Amazon Resource Name (ARN) identifying your CloudFront KeyValueStore"
  value       = aws_cloudfront_key_value_store.this.arn
}

output "etag" {
  description = "ETag hash of the KeyValueStore"
  value       = aws_cloudfront_key_value_store.this.etag
}

output "id" {
  description = "A unique identifier for the KeyValueStore"
  value       = aws_cloudfront_key_value_store.this.id
}