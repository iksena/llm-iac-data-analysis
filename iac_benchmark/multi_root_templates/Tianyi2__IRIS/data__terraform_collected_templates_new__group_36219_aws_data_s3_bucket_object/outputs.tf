output "body" {
  description = "Object data (see limitations above to understand cases in which this field is actually available)"
  value       = data.aws_s3_bucket_object.this.body
}

output "bucket" {
  description = "Name of the bucket to read the object from"
  value       = data.aws_s3_bucket_object.this.bucket
}

output "bucket_key_enabled" {
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS"
  value       = data.aws_s3_bucket_object.this.bucket_key_enabled
}

output "cache_control" {
  description = "Caching behavior along the request/reply chain"
  value       = data.aws_s3_bucket_object.this.cache_control
}

output "content_disposition" {
  description = "Presentational information for the object"
  value       = data.aws_s3_bucket_object.this.content_disposition
}

output "content_encoding" {
  description = "What content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field"
  value       = data.aws_s3_bucket_object.this.content_encoding
}

output "content_language" {
  description = "Language the content is in"
  value       = data.aws_s3_bucket_object.this.content_language
}

output "content_length" {
  description = "Size of the body in bytes"
  value       = data.aws_s3_bucket_object.this.content_length
}

output "content_type" {
  description = "Standard MIME type describing the format of the object data"
  value       = data.aws_s3_bucket_object.this.content_type
}

output "etag" {
  description = "ETag generated for the object (an MD5 sum of the object content in case it's not encrypted)"
  value       = data.aws_s3_bucket_object.this.etag
}

output "expiration" {
  description = "If the object expiration is configured (see object lifecycle management), the field includes this header. It includes the expiry-date and rule-id key value pairs providing object expiration information. The value of the rule-id is URL encoded."
  value       = data.aws_s3_bucket_object.this.expiration
}

output "expires" {
  description = "Date and time at which the object is no longer cacheable"
  value       = data.aws_s3_bucket_object.this.expires
}

output "key" {
  description = "Full path to the object inside the bucket"
  value       = data.aws_s3_bucket_object.this.key
}

output "last_modified" {
  description = "Last modified date of the object in RFC1123 format (e.g., Mon, 02 Jan 2006 15:04:05 MST)"
  value       = data.aws_s3_bucket_object.this.last_modified
}

output "metadata" {
  description = "Map of metadata stored with the object in S3. Keys are always returned in lowercase."
  value       = data.aws_s3_bucket_object.this.metadata
}

output "object_lock_legal_hold_status" {
  description = "Indicates whether this object has an active legal hold. This field is only returned if you have permission to view an object's legal hold status."
  value       = data.aws_s3_bucket_object.this.object_lock_legal_hold_status
}

output "object_lock_mode" {
  description = "Object lock retention mode currently in place for this object"
  value       = data.aws_s3_bucket_object.this.object_lock_mode
}

output "object_lock_retain_until_date" {
  description = "The date and time when this object's object lock will expire"
  value       = data.aws_s3_bucket_object.this.object_lock_retain_until_date
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_s3_bucket_object.this.region
}

output "server_side_encryption" {
  description = "If the object is stored using server-side encryption (KMS or Amazon S3-managed encryption key), this field includes the chosen encryption and algorithm used"
  value       = data.aws_s3_bucket_object.this.server_side_encryption
}

output "sse_kms_key_id" {
  description = "If present, specifies the ID of the Key Management Service (KMS) master encryption key that was used for the object"
  value       = data.aws_s3_bucket_object.this.sse_kms_key_id
}

output "storage_class" {
  description = "Storage class information of the object. Available for all objects except for Standard storage class objects."
  value       = data.aws_s3_bucket_object.this.storage_class
}

output "tags" {
  description = "Map of tags assigned to the object"
  value       = data.aws_s3_bucket_object.this.tags
}

output "version_id" {
  description = "Latest version ID of the object returned"
  value       = data.aws_s3_bucket_object.this.version_id
}

output "website_redirect_location" {
  description = "If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata."
  value       = data.aws_s3_bucket_object.this.website_redirect_location
}