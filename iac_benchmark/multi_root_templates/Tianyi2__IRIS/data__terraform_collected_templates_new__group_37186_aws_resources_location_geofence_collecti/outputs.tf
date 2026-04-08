output "collection_arn" {
  description = "The Amazon Resource Name (ARN) for the geofence collection resource. Used when you need to specify a resource across all AWS."
  value       = aws_location_geofence_collection.this.collection_arn
}

output "create_time" {
  description = "The timestamp for when the geofence collection resource was created in ISO 8601 format."
  value       = aws_location_geofence_collection.this.create_time
}

output "update_time" {
  description = "The timestamp for when the geofence collection resource was last updated in ISO 8601 format."
  value       = aws_location_geofence_collection.this.update_time
}

output "collection_name" {
  description = "The name of the geofence collection."
  value       = aws_location_geofence_collection.this.collection_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_location_geofence_collection.this.region
}

output "description" {
  description = "The description for the geofence collection."
  value       = aws_location_geofence_collection.this.description
}

output "kms_key_id" {
  description = "The KMS customer managed key identifier assigned to the Amazon Location resource."
  value       = aws_location_geofence_collection.this.kms_key_id
}

output "tags" {
  description = "Key-value tags for the geofence collection."
  value       = aws_location_geofence_collection.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_location_geofence_collection.this.tags_all
}