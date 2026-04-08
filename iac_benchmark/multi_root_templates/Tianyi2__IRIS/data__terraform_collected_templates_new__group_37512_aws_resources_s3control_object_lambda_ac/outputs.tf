output "alias" {
  description = "Alias for the S3 Object Lambda Access Point"
  value       = aws_s3control_object_lambda_access_point.this.alias
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the Object Lambda Access Point"
  value       = aws_s3control_object_lambda_access_point.this.arn
}

output "id" {
  description = "The AWS account ID and access point name separated by a colon"
  value       = aws_s3control_object_lambda_access_point.this.id
}