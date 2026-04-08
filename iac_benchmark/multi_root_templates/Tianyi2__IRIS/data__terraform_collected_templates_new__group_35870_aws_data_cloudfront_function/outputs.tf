output "name" {
  description = "Name of the CloudFront function"
  value       = data.aws_cloudfront_function.this.name
}

output "stage" {
  description = "Function's stage"
  value       = data.aws_cloudfront_function.this.stage
}

output "arn" {
  description = "ARN identifying your CloudFront Function"
  value       = data.aws_cloudfront_function.this.arn
}

output "code" {
  description = "Source code of the function"
  value       = data.aws_cloudfront_function.this.code
}

output "comment" {
  description = "Comment"
  value       = data.aws_cloudfront_function.this.comment
}

output "etag" {
  description = "ETag hash of the function"
  value       = data.aws_cloudfront_function.this.etag
}

output "key_value_store_associations" {
  description = "List of aws_cloudfront_key_value_store ARNs associated to the function"
  value       = data.aws_cloudfront_function.this.key_value_store_associations
}

output "last_modified_time" {
  description = "When this resource was last modified"
  value       = data.aws_cloudfront_function.this.last_modified_time
}

output "runtime" {
  description = "Identifier of the function's runtime"
  value       = data.aws_cloudfront_function.this.runtime
}

output "status" {
  description = "Status of the function"
  value       = data.aws_cloudfront_function.this.status
}