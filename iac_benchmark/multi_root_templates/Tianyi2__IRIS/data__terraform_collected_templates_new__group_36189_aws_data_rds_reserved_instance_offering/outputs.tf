output "id" {
  description = "Unique identifier for the reservation. Same as offering_id"
  value       = data.aws_rds_reserved_instance_offering.this.id
}

output "currency_code" {
  description = "Currency code for the reserved DB instance"
  value       = data.aws_rds_reserved_instance_offering.this.currency_code
}

output "fixed_price" {
  description = "Fixed price charged for this reserved DB instance"
  value       = data.aws_rds_reserved_instance_offering.this.fixed_price
}

output "offering_id" {
  description = "Unique identifier for the reservation"
  value       = data.aws_rds_reserved_instance_offering.this.offering_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_rds_reserved_instance_offering.this.region
}

output "db_instance_class" {
  description = "DB instance class for the reserved DB instance"
  value       = data.aws_rds_reserved_instance_offering.this.db_instance_class
}

output "duration" {
  description = "Duration of the reservation in years or seconds"
  value       = data.aws_rds_reserved_instance_offering.this.duration
}

output "multi_az" {
  description = "Whether the reservation applies to Multi-AZ deployments"
  value       = data.aws_rds_reserved_instance_offering.this.multi_az
}

output "offering_type" {
  description = "Offering type of this reserved DB instance"
  value       = data.aws_rds_reserved_instance_offering.this.offering_type
}

output "product_description" {
  description = "Description of the reserved DB instance"
  value       = data.aws_rds_reserved_instance_offering.this.product_description
}