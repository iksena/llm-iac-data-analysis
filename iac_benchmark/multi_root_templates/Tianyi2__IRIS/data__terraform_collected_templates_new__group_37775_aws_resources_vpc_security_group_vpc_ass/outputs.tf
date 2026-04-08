output "region" {
  description = "Region where this resource is managed."
  value       = aws_vpc_security_group_vpc_association.this.region
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = aws_vpc_security_group_vpc_association.this.security_group_id
}

output "vpc_id" {
  description = "The ID of the VPC to make the association with."
  value       = aws_vpc_security_group_vpc_association.this.vpc_id
}

output "state" {
  description = "State of the VPC association."
  value       = aws_vpc_security_group_vpc_association.this.state
}