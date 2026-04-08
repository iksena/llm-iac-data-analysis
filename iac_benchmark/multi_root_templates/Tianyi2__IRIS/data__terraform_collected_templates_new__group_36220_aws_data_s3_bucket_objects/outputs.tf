output "keys" {
  description = "List of strings representing object keys."
  value       = data.aws_s3_bucket_objects.this.keys
}

output "common_prefixes" {
  description = "List of any keys between prefix and the next occurrence of delimiter (i.e., similar to subdirectories of the prefix directory); the list is only returned when you specify delimiter."
  value       = data.aws_s3_bucket_objects.this.common_prefixes
}

output "id" {
  description = "S3 Bucket."
  value       = data.aws_s3_bucket_objects.this.id
}

output "owners" {
  description = "List of strings representing object owner IDs (see fetch_owner above)."
  value       = data.aws_s3_bucket_objects.this.owners
}