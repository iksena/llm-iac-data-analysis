output "arn" {
  description = "ARN of the object"
  value       = aws_s3_object_copy.this.arn
}

output "checksum_crc32" {
  description = "The base64-encoded, 32-bit CRC32 checksum of the object"
  value       = aws_s3_object_copy.this.checksum_crc32
}

output "checksum_crc32c" {
  description = "The base64-encoded, 32-bit CRC32C checksum of the object"
  value       = aws_s3_object_copy.this.checksum_crc32c
}

output "checksum_crc64nvme" {
  description = "The base64-encoded, 64-bit CRC64NVME checksum of the object"
  value       = aws_s3_object_copy.this.checksum_crc64nvme
}

output "checksum_sha1" {
  description = "The base64-encoded, 160-bit SHA-1 digest of the object"
  value       = aws_s3_object_copy.this.checksum_sha1
}

output "checksum_sha256" {
  description = "The base64-encoded, 256-bit SHA-256 digest of the object"
  value       = aws_s3_object_copy.this.checksum_sha256
}

output "etag" {
  description = "ETag generated for the object"
  value       = aws_s3_object_copy.this.etag
}

output "expiration" {
  description = "If the object expiration is configured, this attribute will be set"
  value       = aws_s3_object_copy.this.expiration
}

output "last_modified" {
  description = "Returns the date that the object was last modified"
  value       = aws_s3_object_copy.this.last_modified
}

output "request_charged" {
  description = "If present, indicates that the requester was successfully charged for the request"
  value       = aws_s3_object_copy.this.request_charged
}

output "source_version_id" {
  description = "Version of the copied object in the source bucket"
  value       = aws_s3_object_copy.this.source_version_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider"
  value       = aws_s3_object_copy.this.tags_all
}

output "version_id" {
  description = "Version ID of the newly created copy"
  value       = aws_s3_object_copy.this.version_id
}