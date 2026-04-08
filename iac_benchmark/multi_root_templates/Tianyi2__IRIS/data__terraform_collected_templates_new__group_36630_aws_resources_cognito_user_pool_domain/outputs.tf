output "region" {
  description = "Region where this resource is managed."
  value       = aws_cognito_user_pool_domain.this.region
}

output "domain" {
  description = "The domain name."
  value       = aws_cognito_user_pool_domain.this.domain
}

output "user_pool_id" {
  description = "The user pool ID."
  value       = aws_cognito_user_pool_domain.this.user_pool_id
}

output "certificate_arn" {
  description = "The ARN of the ACM certificate."
  value       = aws_cognito_user_pool_domain.this.certificate_arn
}

output "managed_login_version" {
  description = "The managed login version."
  value       = aws_cognito_user_pool_domain.this.managed_login_version
}

output "aws_account_id" {
  description = "The AWS account ID for the user pool owner."
  value       = aws_cognito_user_pool_domain.this.aws_account_id
}

output "cloudfront_distribution" {
  description = "The Amazon CloudFront endpoint that you use as the target of the alias that you set up with your Domain Name Service (DNS) provider."
  value       = aws_cognito_user_pool_domain.this.cloudfront_distribution
}

output "cloudfront_distribution_arn" {
  description = "The URL of the CloudFront distribution. This is required to generate the ALIAS aws_route53_record."
  value       = aws_cognito_user_pool_domain.this.cloudfront_distribution_arn
}

output "cloudfront_distribution_zone_id" {
  description = "The Route 53 hosted zone ID of the CloudFront distribution."
  value       = aws_cognito_user_pool_domain.this.cloudfront_distribution_zone_id
}

output "s3_bucket" {
  description = "The S3 bucket where the static files for this domain are stored."
  value       = aws_cognito_user_pool_domain.this.s3_bucket
}

output "version" {
  description = "The app version."
  value       = aws_cognito_user_pool_domain.this.version
}