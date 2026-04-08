output "id" {
  description = "The transit gateway route table id suffixed by '-routes'"
  value       = data.aws_ec2_transit_gateway_route_table_routes.this.id
}

output "routes" {
  description = "List of Transit Gateway Routes"
  value       = data.aws_ec2_transit_gateway_route_table_routes.this.routes
}

output "routes_destination_cidr_blocks" {
  description = "List of CIDR blocks used for route destination matches"
  value       = [for route in data.aws_ec2_transit_gateway_route_table_routes.this.routes : route.destination_cidr_block if route.destination_cidr_block != null]
}

output "routes_prefix_list_ids" {
  description = "List of prefix list IDs used for destination matches"
  value       = [for route in data.aws_ec2_transit_gateway_route_table_routes.this.routes : route.prefix_list_id if route.prefix_list_id != null]
}

output "routes_states" {
  description = "List of route states (active, deleted, pending, blackhole, deleting)"
  value       = [for route in data.aws_ec2_transit_gateway_route_table_routes.this.routes : route.state]
}

output "routes_transit_gateway_route_table_announcement_ids" {
  description = "List of transit gateway route table announcement IDs"
  value       = [for route in data.aws_ec2_transit_gateway_route_table_routes.this.routes : route.transit_gateway_route_table_announcement_id]
}

output "routes_types" {
  description = "List of route types (propagated or static)"
  value       = [for route in data.aws_ec2_transit_gateway_route_table_routes.this.routes : route.type]
}