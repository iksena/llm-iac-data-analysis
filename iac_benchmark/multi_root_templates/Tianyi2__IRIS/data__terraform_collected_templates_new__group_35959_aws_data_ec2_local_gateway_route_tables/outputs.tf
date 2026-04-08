output "id" {
  description = "AWS Region."
  value       = data.aws_ec2_local_gateway_route_tables.this.id
}

output "ids" {
  description = "Set of Local Gateway Route Table identifiers"
  value       = data.aws_ec2_local_gateway_route_tables.this.ids
}