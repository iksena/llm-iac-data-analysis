output "id" {
  description = "The Capacity Reservation ID"
  value       = aws_ec2_capacity_reservation.this.id
}

output "owner_id" {
  description = "The ID of the AWS account that owns the Capacity Reservation"
  value       = aws_ec2_capacity_reservation.this.owner_id
}

output "arn" {
  description = "The ARN of the Capacity Reservation"
  value       = aws_ec2_capacity_reservation.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_capacity_reservation.this.tags_all
}