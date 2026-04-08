output "arn" {
  description = "The origin request policy ARN"
  value       = aws_cloudfront_origin_request_policy.this.arn
}

output "etag" {
  description = "The current version of the origin request policy"
  value       = aws_cloudfront_origin_request_policy.this.etag
}

output "id" {
  description = "The identifier for the origin request policy"
  value       = aws_cloudfront_origin_request_policy.this.id
}