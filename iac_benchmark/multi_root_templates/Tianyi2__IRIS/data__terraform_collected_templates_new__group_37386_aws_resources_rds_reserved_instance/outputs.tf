output "arn" {
  description = "ARN for the reserved DB instance."
  value       = aws_rds_reserved_instance.this.arn
}

output "id" {
  description = "Unique identifier for the reservation. same as reservation_id."
  value       = aws_rds_reserved_instance.this.id
}

output "currency_code" {
  description = "Currency code for the reserved DB instance."
  value       = aws_rds_reserved_instance.this.currency_code
}

output "duration" {
  description = "Duration of the reservation in seconds."
  value       = aws_rds_reserved_instance.this.duration
}

output "fixed_price" {
  description = "Fixed price charged for this reserved DB instance."
  value       = aws_rds_reserved_instance.this.fixed_price
}

output "db_instance_class" {
  description = "DB instance class for the reserved DB instance."
  value       = aws_rds_reserved_instance.this.db_instance_class
}

output "lease_id" {
  description = "Unique identifier for the lease associated with the reserved DB instance. Amazon Web Services Support might request the lease ID for an issue related to a reserved DB instance."
  value       = aws_rds_reserved_instance.this.lease_id
}

output "multi_az" {
  description = "Whether the reservation applies to Multi-AZ deployments."
  value       = aws_rds_reserved_instance.this.multi_az
}

output "offering_type" {
  description = "Offering type of this reserved DB instance."
  value       = aws_rds_reserved_instance.this.offering_type
}

output "product_description" {
  description = "Description of the reserved DB instance."
  value       = aws_rds_reserved_instance.this.product_description
}

output "recurring_charges" {
  description = "Recurring price charged to run this reserved DB instance."
  value       = aws_rds_reserved_instance.this.recurring_charges
}

output "start_time" {
  description = "Time the reservation started."
  value       = aws_rds_reserved_instance.this.start_time
}

output "state" {
  description = "State of the reserved DB instance."
  value       = aws_rds_reserved_instance.this.state
}

output "usage_price" {
  description = "Hourly price charged for this reserved DB instance."
  value       = aws_rds_reserved_instance.this.usage_price
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_rds_reserved_instance.this.tags_all
}