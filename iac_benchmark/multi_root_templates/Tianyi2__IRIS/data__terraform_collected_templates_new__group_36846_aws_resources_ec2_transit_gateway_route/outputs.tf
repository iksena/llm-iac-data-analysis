output "id" {
  description = "EC2 Transit Gateway Route Table identifier combined with destination"
  value       = aws_ec2_transit_gateway_route.this.id
}