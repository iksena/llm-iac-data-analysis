output "id" {
  description = "The bucket or bucket and expected_bucket_owner separated by a comma (,) if the latter is provided."
  value       = aws_s3_bucket_request_payment_configuration.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_s3_bucket_request_payment_configuration.this.region
}

output "bucket" {
  description = "Name of the bucket."
  value       = aws_s3_bucket_request_payment_configuration.this.bucket
}

output "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  value       = aws_s3_bucket_request_payment_configuration.this.expected_bucket_owner
}

output "payer" {
  description = "Specifies who pays for the download and request fees."
  value       = aws_s3_bucket_request_payment_configuration.this.payer
}