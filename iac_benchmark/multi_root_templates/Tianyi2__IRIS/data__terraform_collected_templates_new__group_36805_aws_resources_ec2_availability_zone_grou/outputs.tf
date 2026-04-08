output "id" {
  description = "Name of the Availability Zone Group."
  value       = aws_ec2_availability_zone_group.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ec2_availability_zone_group.this.region
}

output "group_name" {
  description = "Name of the Availability Zone Group."
  value       = aws_ec2_availability_zone_group.this.group_name
}

output "opt_in_status" {
  description = "Indicates whether to enable or disable Availability Zone Group."
  value       = aws_ec2_availability_zone_group.this.opt_in_status
}