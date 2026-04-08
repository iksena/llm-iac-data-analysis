output "id" {
  description = "AWS Region."
  value       = data.aws_ec2_transit_gateway_route_table_propagations.this.id
}

output "ids" {
  description = "Set of Transit Gateway Route Table Association identifiers."
  value       = data.aws_ec2_transit_gateway_route_table_propagations.this.ids
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_transit_gateway_route_table_propagations.this.region
}

output "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table."
  value       = data.aws_ec2_transit_gateway_route_table_propagations.this.transit_gateway_route_table_id
}

output "filter" {
  description = "Custom filter block used for filtering."
  value       = var.filter
}