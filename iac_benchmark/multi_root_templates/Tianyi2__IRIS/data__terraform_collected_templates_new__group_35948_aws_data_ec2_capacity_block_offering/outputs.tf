output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_ec2_capacity_block_offering.this.region
}

output "capacity_duration_hours" {
  description = "The amount of time of the Capacity Block reservation in hours."
  value       = data.aws_ec2_capacity_block_offering.this.capacity_duration_hours
}

output "end_date_range" {
  description = "The date and time at which the Capacity Block Reservation expires."
  value       = data.aws_ec2_capacity_block_offering.this.end_date_range
}

output "instance_count" {
  description = "The number of instances for which to reserve capacity."
  value       = data.aws_ec2_capacity_block_offering.this.instance_count
}

output "instance_type" {
  description = "The instance type for which to reserve capacity."
  value       = data.aws_ec2_capacity_block_offering.this.instance_type
}

output "start_date_range" {
  description = "The date and time at which the Capacity Block Reservation starts."
  value       = data.aws_ec2_capacity_block_offering.this.start_date_range
}

output "availability_zone" {
  description = "The Availability Zone in which to create the Capacity Reservation."
  value       = data.aws_ec2_capacity_block_offering.this.availability_zone
}

output "currency_code" {
  description = "The currency of the payment for the Capacity Block."
  value       = data.aws_ec2_capacity_block_offering.this.currency_code
}

output "capacity_block_offering_id" {
  description = "The Capacity Block Reservation ID."
  value       = data.aws_ec2_capacity_block_offering.this.capacity_block_offering_id
}

output "upfront_fee" {
  description = "The total price to be paid up front."
  value       = data.aws_ec2_capacity_block_offering.this.upfront_fee
}

output "tenancy" {
  description = "Indicates the tenancy of the Capacity Reservation. Specify either default or dedicated."
  value       = data.aws_ec2_capacity_block_offering.this.tenancy
}