output "create_time" {
  description = "Timestamp for when the tracker resource was created in ISO 8601 format."
  value       = data.aws_location_tracker.this.create_time
}

output "description" {
  description = "Optional description for the tracker resource."
  value       = data.aws_location_tracker.this.description
}

output "kms_key_id" {
  description = "Key identifier for an AWS KMS customer managed key assigned to the Amazon Location resource."
  value       = data.aws_location_tracker.this.kms_key_id
}

output "position_filtering" {
  description = "Position filtering method of the tracker resource."
  value       = data.aws_location_tracker.this.position_filtering
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_location_tracker.this.region
}

output "tags" {
  description = "Key-value map of resource tags for the tracker."
  value       = data.aws_location_tracker.this.tags
}

output "tracker_arn" {
  description = "ARN for the tracker resource. Used when you need to specify a resource across all AWS."
  value       = data.aws_location_tracker.this.tracker_arn
}

output "tracker_name" {
  description = "Name of the tracker resource."
  value       = data.aws_location_tracker.this.tracker_name
}

output "update_time" {
  description = "Timestamp for when the tracker resource was last updated in ISO 8601 format."
  value       = data.aws_location_tracker.this.update_time
}