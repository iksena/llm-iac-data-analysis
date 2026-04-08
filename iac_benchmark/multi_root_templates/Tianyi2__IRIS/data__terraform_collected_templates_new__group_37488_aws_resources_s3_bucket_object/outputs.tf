output "arn" {
  description = "ARN of the object."
  value       = aws_s3_bucket_object.this.arn
}

output "etag" {
  description = "ETag generated for the object (an MD5 sum of the object content). For plaintext objects or objects encrypted with an AWS-managed key, the hash is an MD5 digest of the object data. For objects encrypted with a KMS key or objects created by either the Multipart Upload or Part Copy operation, the hash is not an MD5 digest, regardless of the method of encryption."
  value       = aws_s3_bucket_object.this.etag
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3_bucket_object.this.tags_all
}

output "version_id" {
  description = "Unique version ID value for the object, if bucket versioning is enabled."
  value       = aws_s3_bucket_object.this.version_id
}