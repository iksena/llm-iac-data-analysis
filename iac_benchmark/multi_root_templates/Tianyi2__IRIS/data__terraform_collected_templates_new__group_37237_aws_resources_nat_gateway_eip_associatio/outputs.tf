
output "allocation_id" {
  description = "The ID of the Elastic IP Allocation associated with the NAT Gateway."
  value       = aws_nat_gateway_eip_association.this.allocation_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway associated with the Elastic IP Allocation."
  value       = aws_nat_gateway_eip_association.this.nat_gateway_id
}