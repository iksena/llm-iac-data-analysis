output "arn" {
  description = "EC2 Transit Gateway Route Table ARN."
  value       = data.aws_ec2_transit_gateway_route_table.this.arn
}

output "default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway."
  value       = data.aws_ec2_transit_gateway_route_table.this.default_association_route_table
}

output "default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway."
  value       = data.aws_ec2_transit_gateway_route_table.this.default_propagation_route_table
}

output "id" {
  description = "EC2 Transit Gateway Route Table identifier."
  value       = data.aws_ec2_transit_gateway_route_table.this.id
}

output "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier."
  value       = data.aws_ec2_transit_gateway_route_table.this.transit_gateway_id
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Route Table."
  value       = data.aws_ec2_transit_gateway_route_table.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_transit_gateway_route_table.this.region
}