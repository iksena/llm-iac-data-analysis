output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the public key configuration"
  value       = aws_cloudfront_public_key.this.caller_reference
}

output "etag" {
  description = "The current version of the public key"
  value       = aws_cloudfront_public_key.this.etag
}

output "id" {
  description = "The identifier for the public key"
  value       = aws_cloudfront_public_key.this.id
}

output "comment" {
  description = "An optional comment about the public key"
  value       = aws_cloudfront_public_key.this.comment
}

output "encoded_key" {
  description = "The encoded public key that you want to add to CloudFront to use with features like field-level encryption"
  value       = aws_cloudfront_public_key.this.encoded_key
  sensitive   = true
}

output "name" {
  description = "The name for the public key"
  value       = aws_cloudfront_public_key.this.name
}

output "name_prefix" {
  description = "The name prefix for the public key"
  value       = aws_cloudfront_public_key.this.name_prefix
}