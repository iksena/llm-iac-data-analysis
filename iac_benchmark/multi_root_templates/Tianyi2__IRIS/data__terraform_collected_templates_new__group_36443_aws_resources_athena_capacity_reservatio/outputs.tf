output "allocated_dpus" {
  description = "Number of data processing units currently allocated."
  value       = aws_athena_capacity_reservation.this.allocated_dpus
}

output "arn" {
  description = "ARN of the Capacity Reservation."
  value       = aws_athena_capacity_reservation.this.arn
}

output "status" {
  description = "Status of the capacity reservation."
  value       = aws_athena_capacity_reservation.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_athena_capacity_reservation.this.tags_all
}

output "name" {
  description = "Name of the capacity reservation."
  value       = aws_athena_capacity_reservation.this.name
}

output "target_dpus" {
  description = "Number of data processing units requested."
  value       = aws_athena_capacity_reservation.this.target_dpus
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_athena_capacity_reservation.this.region
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_athena_capacity_reservation.this.tags
}