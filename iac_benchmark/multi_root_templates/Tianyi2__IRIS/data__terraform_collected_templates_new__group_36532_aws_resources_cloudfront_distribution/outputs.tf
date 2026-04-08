output "id" {
  description = "Identifier for the distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "arn" {
  description = "ARN for the distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration"
  value       = aws_cloudfront_distribution.this.caller_reference
}

output "status" {
  description = "Current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system"
  value       = aws_cloudfront_distribution.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cloudfront_distribution.this.tags_all
}

output "trusted_key_groups" {
  description = "List of nested attributes for active trusted key groups, if the distribution is set up to serve private content with signed URLs"
  value       = aws_cloudfront_distribution.this.trusted_key_groups
}

output "trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = aws_cloudfront_distribution.this.trusted_signers
}

output "domain_name" {
  description = "Domain name corresponding to the distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "last_modified_time" {
  description = "Date and time the distribution was last modified"
  value       = aws_cloudfront_distribution.this.last_modified_time
}

output "in_progress_validation_batches" {
  description = "Number of invalidation batches currently in progress"
  value       = aws_cloudfront_distribution.this.in_progress_validation_batches
}

output "etag" {
  description = "Current version of the distribution's information"
  value       = aws_cloudfront_distribution.this.etag
}

output "hosted_zone_id" {
  description = "CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. This attribute is simply an alias for the zone ID Z2FDTNDATAQYW2"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}