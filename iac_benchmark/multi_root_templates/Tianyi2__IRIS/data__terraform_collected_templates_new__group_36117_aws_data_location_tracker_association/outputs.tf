output "consumer_arn" {
  description = "ARN of the geofence collection associated to tracker resource"
  value       = data.aws_location_tracker_association.this.consumer_arn
}

output "tracker_name" {
  description = "Name of the tracker resource associated with a geofence collection"
  value       = data.aws_location_tracker_association.this.tracker_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_location_tracker_association.this.region
}