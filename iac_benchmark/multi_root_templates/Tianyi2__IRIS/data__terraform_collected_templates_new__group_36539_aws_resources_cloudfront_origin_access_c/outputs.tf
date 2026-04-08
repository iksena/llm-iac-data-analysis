output "arn" {
  description = "The Origin Access Control ARN."
  value       = aws_cloudfront_origin_access_control.this.arn
}

output "id" {
  description = "The unique identifier of this Origin Access Control."
  value       = aws_cloudfront_origin_access_control.this.id
}

output "etag" {
  description = "The current version of this Origin Access Control."
  value       = aws_cloudfront_origin_access_control.this.etag
}