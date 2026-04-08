output "id" {
  description = "AWS Region"
  value       = data.aws_ec2_transit_gateway_route_table_associations.this.id
}

output "ids" {
  description = "Set of Transit Gateway Route Table Association identifiers"
  value       = data.aws_ec2_transit_gateway_route_table_associations.this.ids
}

output "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table"
  value       = data.aws_ec2_transit_gateway_route_table_associations.this.transit_gateway_route_table_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ec2_transit_gateway_route_table_associations.this.region
}

output "filters" {
  description = "Applied filters for the data source"
  value       = var.filters
}