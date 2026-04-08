output "id" {
  description = "Unique identifier (ID) of the appstream fleet"
  value       = aws_appstream_fleet.this.id
}

output "arn" {
  description = "ARN of the appstream fleet"
  value       = aws_appstream_fleet.this.arn
}

output "state" {
  description = "State of the fleet. Can be STARTING, RUNNING, STOPPING or STOPPED"
  value       = aws_appstream_fleet.this.state
}

output "created_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, when the fleet was created"
  value       = aws_appstream_fleet.this.created_time
}

output "compute_capacity" {
  description = "Describes the capacity status for a fleet"
  value       = aws_appstream_fleet.this.compute_capacity
}

output "compute_capacity_available" {
  description = "Number of currently available instances that can be used to stream sessions"
  value       = try(aws_appstream_fleet.this.compute_capacity[0].available, null)
}

output "compute_capacity_in_use" {
  description = "Number of instances in use for streaming"
  value       = try(aws_appstream_fleet.this.compute_capacity[0].in_use, null)
}

output "compute_capacity_running" {
  description = "Total number of simultaneous streaming instances that are running"
  value       = try(aws_appstream_fleet.this.compute_capacity[0].running, null)
}