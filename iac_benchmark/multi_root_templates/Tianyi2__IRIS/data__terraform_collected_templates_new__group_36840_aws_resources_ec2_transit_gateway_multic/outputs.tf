output "id" {
  description = "EC2 Transit Gateway Multicast Group Member identifier"
  value       = aws_ec2_transit_gateway_multicast_group_source.this.id
}