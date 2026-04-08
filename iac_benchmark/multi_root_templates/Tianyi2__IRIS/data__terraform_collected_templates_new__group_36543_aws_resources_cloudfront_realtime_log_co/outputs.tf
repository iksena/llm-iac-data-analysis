output "id" {
  description = "The ID of the CloudFront real-time log configuration"
  value       = aws_cloudfront_realtime_log_config.this.id
}

output "arn" {
  description = "The ARN (Amazon Resource Name) of the CloudFront real-time log configuration"
  value       = aws_cloudfront_realtime_log_config.this.arn
}