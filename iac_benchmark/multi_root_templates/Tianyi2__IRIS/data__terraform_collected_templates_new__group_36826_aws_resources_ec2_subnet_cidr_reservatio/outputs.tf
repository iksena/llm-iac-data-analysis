output "id" {
  description = "ID of the CIDR reservation"
  value       = aws_ec2_subnet_cidr_reservation.this.id
}

output "owner_id" {
  description = "ID of the AWS account that owns this CIDR reservation"
  value       = aws_ec2_subnet_cidr_reservation.this.owner_id
}

output "cidr_block" {
  description = "The CIDR block for the reservation"
  value       = aws_ec2_subnet_cidr_reservation.this.cidr_block
}

output "reservation_type" {
  description = "The type of reservation"
  value       = aws_ec2_subnet_cidr_reservation.this.reservation_type
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_ec2_subnet_cidr_reservation.this.subnet_id
}

output "description" {
  description = "The description of the reservation"
  value       = aws_ec2_subnet_cidr_reservation.this.description
}

output "region" {
  description = "The region of the reservation"
  value       = aws_ec2_subnet_cidr_reservation.this.region
}