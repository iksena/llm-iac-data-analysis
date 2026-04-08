output "arn" {
  description = "Amazon Resource Name (ARN) identifying your CloudFront Function."
  value       = aws_cloudfront_function.this.arn
}

output "etag" {
  description = "ETag hash of the function. This is the value for the DEVELOPMENT stage of the function."
  value       = aws_cloudfront_function.this.etag
}

output "live_stage_etag" {
  description = "ETag hash of any LIVE stage of the function."
  value       = aws_cloudfront_function.this.live_stage_etag
}

output "status" {
  description = "Status of the function. Can be UNPUBLISHED, UNASSOCIATED or ASSOCIATED."
  value       = aws_cloudfront_function.this.status
}