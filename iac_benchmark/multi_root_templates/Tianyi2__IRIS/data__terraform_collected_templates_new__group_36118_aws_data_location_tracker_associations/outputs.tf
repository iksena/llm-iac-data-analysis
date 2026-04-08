output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_location_tracker_associations.this.region
}

output "tracker_name" {
  description = "Name of the tracker resource associated with a geofence collection."
  value       = data.aws_location_tracker_associations.this.tracker_name
}

output "consumer_arns" {
  description = "List of geofence collection ARNs associated to the tracker resource."
  value       = data.aws_location_tracker_associations.this.consumer_arns
}