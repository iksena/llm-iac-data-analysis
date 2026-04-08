output "arn" {
  description = "The ARN of the reservation"
  value       = aws_ec2_capacity_block_reservation.this.arn
}

output "availability_zone" {
  description = "The Availability Zone in which to create the Capacity Block Reservation"
  value       = aws_ec2_capacity_block_reservation.this.availability_zone
}

output "created_date" {
  description = "The date and time at which the Capacity Block Reservation was created"
  value       = aws_ec2_capacity_block_reservation.this.created_date
}

output "ebs_optimized" {
  description = "Indicates whether the Capacity Reservation supports EBS-optimized instances"
  value       = aws_ec2_capacity_block_reservation.this.ebs_optimized
}

output "end_date" {
  description = "The date and time at which the Capacity Block Reservation expires"
  value       = aws_ec2_capacity_block_reservation.this.end_date
}

output "end_date_type" {
  description = "Indicates the way in which the Capacity Reservation ends"
  value       = aws_ec2_capacity_block_reservation.this.end_date_type
}

output "id" {
  description = "The ID of the Capacity Block Reservation"
  value       = aws_ec2_capacity_block_reservation.this.id
}

output "instance_count" {
  description = "The number of instances for which to reserve capacity"
  value       = aws_ec2_capacity_block_reservation.this.instance_count
}

output "instance_type" {
  description = "The instance type for which to reserve capacity"
  value       = aws_ec2_capacity_block_reservation.this.instance_type
}

output "outpost_arn" {
  description = "The ARN of the Outpost on which to create the Capacity Block Reservation"
  value       = aws_ec2_capacity_block_reservation.this.outpost_arn
}

output "placement_group_arn" {
  description = "The ARN of the placement group in which to create the Capacity Block Reservation"
  value       = aws_ec2_capacity_block_reservation.this.placement_group_arn
}

output "reservation_type" {
  description = "The type of Capacity Reservation"
  value       = aws_ec2_capacity_block_reservation.this.reservation_type
}

output "start_date" {
  description = "The date and time at which the Capacity Block Reservation starts"
  value       = aws_ec2_capacity_block_reservation.this.start_date
}

output "tenancy" {
  description = "Indicates the tenancy of the Capacity Block Reservation"
  value       = aws_ec2_capacity_block_reservation.this.tenancy
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_capacity_block_reservation.this.tags_all
}