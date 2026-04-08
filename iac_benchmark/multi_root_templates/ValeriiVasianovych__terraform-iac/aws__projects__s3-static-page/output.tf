output "region" {
  value = data.aws_region.current.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "bucket_name" {
  value = aws_s3_bucket.static_website.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.static_website.arn
}

output "bucket_website_domain" {
  value = "http://${var.bucket_name}"
}

output "bucket_website_domain_www" {
  value = "http://www.${var.bucket_name}"
}

