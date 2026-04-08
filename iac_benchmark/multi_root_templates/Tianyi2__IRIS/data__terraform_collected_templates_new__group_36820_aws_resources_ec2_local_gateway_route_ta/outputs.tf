output "id" {
  description = "Identifier of EC2 Local Gateway Route Table VPC Association"
  value       = aws_ec2_local_gateway_route_table_vpc_association.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_local_gateway_route_table_vpc_association.this.tags_all
}

output "local_gateway_route_table_id" {
  description = "Identifier of EC2 Local Gateway Route Table"
  value       = aws_ec2_local_gateway_route_table_vpc_association.this.local_gateway_route_table_id
}

output "vpc_id" {
  description = "Identifier of EC2 VPC"
  value       = aws_ec2_local_gateway_route_table_vpc_association.this.vpc_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ec2_local_gateway_route_table_vpc_association.this.region
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = aws_ec2_local_gateway_route_table_vpc_association.this.tags
}