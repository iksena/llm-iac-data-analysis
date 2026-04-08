output "arn" {
  description = "The Field Level Encryption Config ARN"
  value       = aws_cloudfront_field_level_encryption_config.this.arn
}

output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the Field Level Encryption Config"
  value       = aws_cloudfront_field_level_encryption_config.this.caller_reference
}

output "etag" {
  description = "The current version of the Field Level Encryption Config"
  value       = aws_cloudfront_field_level_encryption_config.this.etag
}

output "id" {
  description = "The identifier for the Field Level Encryption Config"
  value       = aws_cloudfront_field_level_encryption_config.this.id
}