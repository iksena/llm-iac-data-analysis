output "arn" {
  description = "ARN of the object."
  value       = aws_s3_object.this.arn
}

output "bucket" {
  description = "Name of the bucket."
  value       = aws_s3_object.this.bucket
}

output "key" {
  description = "Name of the object."
  value       = aws_s3_object.this.key
}

output "acl" {
  description = "Canned ACL applied to the object."
  value       = aws_s3_object.this.acl
}

output "bucket_key_enabled" {
  description = "Whether Amazon S3 Bucket Keys are used for SSE-KMS."
  value       = aws_s3_object.this.bucket_key_enabled
}

output "cache_control" {
  description = "Caching behavior along the request/reply chain."
  value       = aws_s3_object.this.cache_control
}

output "checksum_algorithm" {
  description = "Algorithm used to create the checksum for the object."
  value       = aws_s3_object.this.checksum_algorithm
}

output "checksum_crc32" {
  description = "The base64-encoded, 32-bit CRC32 checksum of the object."
  value       = aws_s3_object.this.checksum_crc32
}

output "checksum_crc32c" {
  description = "The base64-encoded, 32-bit CRC32C checksum of the object."
  value       = aws_s3_object.this.checksum_crc32c
}

output "checksum_crc64nvme" {
  description = "The base64-encoded, 64-bit CRC64NVME checksum of the object."
  value       = aws_s3_object.this.checksum_crc64nvme
}

output "checksum_sha1" {
  description = "The base64-encoded, 160-bit SHA-1 digest of the object."
  value       = aws_s3_object.this.checksum_sha1
}

output "checksum_sha256" {
  description = "The base64-encoded, 256-bit SHA-256 digest of the object."
  value       = aws_s3_object.this.checksum_sha256
}

output "content_base64" {
  description = "Base64-encoded data used as object content."
  value       = aws_s3_object.this.content_base64
}

output "content_disposition" {
  description = "Presentational information for the object."
  value       = aws_s3_object.this.content_disposition
}

output "content_encoding" {
  description = "Content encodings applied to the object."
  value       = aws_s3_object.this.content_encoding
}

output "content_language" {
  description = "Language the content is in."
  value       = aws_s3_object.this.content_language
}

output "content_type" {
  description = "Standard MIME type describing the format of the object data."
  value       = aws_s3_object.this.content_type
}

output "content" {
  description = "Literal string value used as object content."
  value       = aws_s3_object.this.content
}

output "etag" {
  description = "ETag generated for the object (an MD5 sum of the object content)."
  value       = aws_s3_object.this.etag
}

output "force_destroy" {
  description = "Whether the object can be deleted by removing any legal hold."
  value       = aws_s3_object.this.force_destroy
}

output "kms_key_id" {
  description = "ARN of the KMS Key used for object encryption."
  value       = aws_s3_object.this.kms_key_id
}

output "metadata" {
  description = "Map of keys/values for object metadata."
  value       = aws_s3_object.this.metadata
}

output "object_lock_legal_hold_status" {
  description = "Legal hold status applied to the object."
  value       = aws_s3_object.this.object_lock_legal_hold_status
}

output "object_lock_mode" {
  description = "Object lock retention mode applied to the object."
  value       = aws_s3_object.this.object_lock_mode
}

output "object_lock_retain_until_date" {
  description = "Date and time when the object's object lock will expire."
  value       = aws_s3_object.this.object_lock_retain_until_date
}

output "server_side_encryption" {
  description = "Server-side encryption of the object in S3."
  value       = aws_s3_object.this.server_side_encryption
}

output "source_hash" {
  description = "Hash used to trigger updates."
  value       = aws_s3_object.this.source_hash
}

output "source" {
  description = "Path to the file used as object content."
  value       = aws_s3_object.this.source
}

output "storage_class" {
  description = "Storage Class for the object."
  value       = aws_s3_object.this.storage_class
}

output "region" {
  description = "Region where the resource is managed."
  value       = aws_s3_object.this.region
}

output "tags" {
  description = "Map of tags assigned to the object."
  value       = aws_s3_object.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3_object.this.tags_all
}

output "version_id" {
  description = "Unique version ID value for the object, if bucket versioning is enabled."
  value       = aws_s3_object.this.version_id
}

output "website_redirect" {
  description = "Target URL for website redirect."
  value       = aws_s3_object.this.website_redirect
}