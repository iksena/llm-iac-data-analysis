output "id" {
  description = "The bucket and inventory configuration name separated by a colon (:)."
  value       = aws_s3_bucket_inventory.this.id
}

output "bucket" {
  description = "Name of the source bucket that inventory lists the objects for."
  value       = aws_s3_bucket_inventory.this.bucket
}

output "name" {
  description = "Unique identifier of the inventory configuration for the bucket."
  value       = aws_s3_bucket_inventory.this.name
}

output "included_object_versions" {
  description = "Object versions included in the inventory list."
  value       = aws_s3_bucket_inventory.this.included_object_versions
}

output "enabled" {
  description = "Whether the inventory is enabled or disabled."
  value       = aws_s3_bucket_inventory.this.enabled
}

output "schedule" {
  description = "The schedule for generating inventory results."
  value       = aws_s3_bucket_inventory.this.schedule
}

output "destination" {
  description = "Information about where inventory results are published."
  value       = aws_s3_bucket_inventory.this.destination
}

output "filter" {
  description = "The inventory filter configuration."
  value       = aws_s3_bucket_inventory.this.filter
}

output "optional_fields" {
  description = "List of optional fields included in the inventory results."
  value       = aws_s3_bucket_inventory.this.optional_fields
}