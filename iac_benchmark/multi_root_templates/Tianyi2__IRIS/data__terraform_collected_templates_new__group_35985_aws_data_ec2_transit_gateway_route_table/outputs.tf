output "id" {
  description = "AWS Region"
  value       = data.aws_ec2_transit_gateway_route_tables.this.id
}

output "ids" {
  description = "Set of Transit Gateway Route Table identifiers"
  value       = data.aws_ec2_transit_gateway_route_tables.this.ids
}