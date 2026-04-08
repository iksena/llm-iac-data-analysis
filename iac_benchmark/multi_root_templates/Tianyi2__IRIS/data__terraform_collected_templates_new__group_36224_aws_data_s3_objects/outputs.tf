output "keys" {
  description = "List of strings representing object keys"
  value       = data.aws_s3_objects.this.keys
}

output "common_prefixes" {
  description = "List of any keys between prefix and the next occurrence of delimiter (i.e., similar to subdirectories of the prefix \"directory\"); the list is only returned when you specify delimiter"
  value       = data.aws_s3_objects.this.common_prefixes
}

output "id" {
  description = "S3 Bucket"
  value       = data.aws_s3_objects.this.id
}

output "owners" {
  description = "List of strings representing object owner IDs"
  value       = data.aws_s3_objects.this.owners
}

output "request_charged" {
  description = "If present, indicates that the requester was successfully charged for the request"
  value       = data.aws_s3_objects.this.request_charged
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_s3_objects.this.region
}

output "bucket" {
  description = "S3 bucket name"
  value       = data.aws_s3_objects.this.bucket
}

output "prefix" {
  description = "Prefix used to limit results to object keys"
  value       = data.aws_s3_objects.this.prefix
}

output "delimiter" {
  description = "Character used to group keys"
  value       = data.aws_s3_objects.this.delimiter
}

output "encoding_type" {
  description = "Method used to encode keys"
  value       = data.aws_s3_objects.this.encoding_type
}

output "max_keys" {
  description = "Maximum object keys returned"
  value       = data.aws_s3_objects.this.max_keys
}

output "start_after" {
  description = "Object key used as starting point for lexicographical listing"
  value       = data.aws_s3_objects.this.start_after
}

output "fetch_owner" {
  description = "Whether owner list is populated"
  value       = data.aws_s3_objects.this.fetch_owner
}

output "request_payer" {
  description = "Request payer setting"
  value       = data.aws_s3_objects.this.request_payer
}