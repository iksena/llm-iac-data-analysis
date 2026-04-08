output "tracker_name" {
  description = "The name of the tracker resource"
  value       = aws_location_tracker.this.tracker_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_location_tracker.this.region
}

output "description" {
  description = "The description for the tracker resource"
  value       = aws_location_tracker.this.description
}

output "kms_key_id" {
  description = "The AWS KMS customer managed key assigned to the Amazon Location resource"
  value       = aws_location_tracker.this.kms_key_id
}

output "position_filtering" {
  description = "The position filtering method of the tracker resource"
  value       = aws_location_tracker.this.position_filtering
}

output "tags" {
  description = "Key-value tags for the tracker"
  value       = aws_location_tracker.this.tags
}

output "create_time" {
  description = "The timestamp for when the tracker resource was created in ISO 8601 format"
  value       = aws_location_tracker.this.create_time
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_location_tracker.this.tags_all
}

output "tracker_arn" {
  description = "The Amazon Resource Name (ARN) for the tracker resource. Used when you need to specify a resource across all AWS"
  value       = aws_location_tracker.this.tracker_arn
}

output "update_time" {
  description = "The timestamp for when the tracker resource was last updated in ISO 8601 format"
  value       = aws_location_tracker.this.update_time
}