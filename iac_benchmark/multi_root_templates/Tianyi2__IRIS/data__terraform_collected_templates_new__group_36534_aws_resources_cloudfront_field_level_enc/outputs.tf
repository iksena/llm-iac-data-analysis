output "arn" {
  value       = aws_cloudfront_field_level_encryption_profile.this.arn
  description = "The Field Level Encryption Profile ARN."
}

output "caller_reference" {
  value       = aws_cloudfront_field_level_encryption_profile.this.caller_reference
  description = "Internal value used by CloudFront to allow future updates to the Field Level Encryption Profile."
}

output "etag" {
  value       = aws_cloudfront_field_level_encryption_profile.this.etag
  description = "The current version of the Field Level Encryption Profile."
}

output "id" {
  value       = aws_cloudfront_field_level_encryption_profile.this.id
  description = "The identifier for the Field Level Encryption Profile."
}