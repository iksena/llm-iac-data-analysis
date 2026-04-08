output "arn" {
  description = "The origin access identity ARN"
  value       = aws_cloudfront_origin_access_identity.this.arn
}

output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the origin access identity"
  value       = aws_cloudfront_origin_access_identity.this.caller_reference
}

output "cloudfront_access_identity_path" {
  description = "A shortcut to the full path for the origin access identity to use in CloudFront"
  value       = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
}

output "etag" {
  description = "The current version of the origin access identity's information"
  value       = aws_cloudfront_origin_access_identity.this.etag
}

output "iam_arn" {
  description = "A pre-generated ARN for use in S3 bucket policies"
  value       = aws_cloudfront_origin_access_identity.this.iam_arn
}

output "id" {
  description = "The identifier for the origin access identity"
  value       = aws_cloudfront_origin_access_identity.this.id
}

output "s3_canonical_user_id" {
  description = "The Amazon S3 canonical user ID for the origin access identity"
  value       = aws_cloudfront_origin_access_identity.this.s3_canonical_user_id
}