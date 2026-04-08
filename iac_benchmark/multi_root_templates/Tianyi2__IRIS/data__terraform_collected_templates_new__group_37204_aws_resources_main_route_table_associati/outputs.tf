output "id" {
  description = "The ID of the Route Table Association"
  value       = aws_main_route_table_association.this.id
}

output "original_route_table_id" {
  description = "Used internally, see Notes in documentation"
  value       = aws_main_route_table_association.this.original_route_table_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_main_route_table_association.this.region
}

output "vpc_id" {
  description = "The ID of the VPC whose main route table is set"
  value       = aws_main_route_table_association.this.vpc_id
}

output "route_table_id" {
  description = "The ID of the Route Table set as the new main route table for the target VPC"
  value       = aws_main_route_table_association.this.route_table_id
}