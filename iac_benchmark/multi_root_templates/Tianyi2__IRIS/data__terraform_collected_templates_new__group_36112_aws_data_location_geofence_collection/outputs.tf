output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_location_geofence_collection.this.region
}

output "collection_name" {
  description = "Name of the geofence collection."
  value       = data.aws_location_geofence_collection.this.collection_name
}

output "collection_arn" {
  description = "ARN for the geofence collection resource. Used when you need to specify a resource across all AWS."
  value       = data.aws_location_geofence_collection.this.collection_arn
}

output "create_time" {
  description = "Timestamp for when the geofence collection resource was created in ISO 8601 format."
  value       = data.aws_location_geofence_collection.this.create_time
}

output "description" {
  description = "Optional description of the geofence collection resource."
  value       = data.aws_location_geofence_collection.this.description
}

output "kms_key_id" {
  description = "Key identifier for an AWS KMS customer managed key assigned to the Amazon Location resource."
  value       = data.aws_location_geofence_collection.this.kms_key_id
}

output "tags" {
  description = "Key-value map of resource tags for the geofence collection."
  value       = data.aws_location_geofence_collection.this.tags
}

output "update_time" {
  description = "Timestamp for when the geofence collection resource was last updated in ISO 8601 format."
  value       = data.aws_location_geofence_collection.this.update_time
}