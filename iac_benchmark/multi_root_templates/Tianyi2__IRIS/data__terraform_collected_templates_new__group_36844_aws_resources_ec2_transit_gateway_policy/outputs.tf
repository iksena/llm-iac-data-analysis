output "id" {
  description = "EC2 Transit Gateway Policy Table identifier combined with EC2 Transit Gateway Attachment identifier"
  value       = aws_ec2_transit_gateway_policy_table_association.this.id
}

output "resource_id" {
  description = "Identifier of the resource"
  value       = aws_ec2_transit_gateway_policy_table_association.this.resource_id
}

output "resource_type" {
  description = "Type of the resource"
  value       = aws_ec2_transit_gateway_policy_table_association.this.resource_type
}