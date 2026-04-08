output "arn" {
  description = "The Amazon Resource Name of this upload."
  value       = aws_devicefarm_upload.this.arn
}

output "url" {
  description = "The presigned Amazon S3 URL that was used to store a file using a PUT request."
  value       = aws_devicefarm_upload.this.url
}

output "category" {
  description = "The upload's category."
  value       = aws_devicefarm_upload.this.category
}

output "metadata" {
  description = "The upload's metadata. For example, for Android, this contains information that is parsed from the manifest and is displayed in the AWS Device Farm console after the associated app is uploaded."
  value       = aws_devicefarm_upload.this.metadata
}