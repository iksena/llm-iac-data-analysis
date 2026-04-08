output "arn" {
  description = "EC2 Transit Gateway Route Table Amazon Resource Name (ARN)"
  value       = aws_ec2_transit_gateway_route_table.this.arn
}

output "default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = aws_ec2_transit_gateway_route_table.this.default_association_route_table
}

output "default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = aws_ec2_transit_gateway_route_table.this.default_propagation_route_table
}

output "id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = aws_ec2_transit_gateway_route_table.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_transit_gateway_route_table.this.tags_all
}