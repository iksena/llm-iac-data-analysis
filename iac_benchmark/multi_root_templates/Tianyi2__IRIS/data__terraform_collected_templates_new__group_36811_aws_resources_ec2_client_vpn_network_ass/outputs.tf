output "id" {
  description = "The unique ID of the target network association."
  value       = aws_ec2_client_vpn_network_association.this.id
}

output "association_id" {
  description = "The unique ID of the target network association."
  value       = aws_ec2_client_vpn_network_association.this.association_id
}

output "vpc_id" {
  description = "The ID of the VPC in which the target subnet is located."
  value       = aws_ec2_client_vpn_network_association.this.vpc_id
}