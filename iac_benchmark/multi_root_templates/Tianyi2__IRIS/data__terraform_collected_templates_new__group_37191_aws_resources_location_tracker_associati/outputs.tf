output "id" {
  description = "The ID of the tracker association (tracker_name|consumer_arn)."
  value       = aws_location_tracker_association.this.id
}

output "consumer_arn" {
  description = "The Amazon Resource Name (ARN) for the geofence collection associated to tracker resource."
  value       = aws_location_tracker_association.this.consumer_arn
}

output "tracker_name" {
  description = "The name of the tracker resource associated with a geofence collection."
  value       = aws_location_tracker_association.this.tracker_name
}