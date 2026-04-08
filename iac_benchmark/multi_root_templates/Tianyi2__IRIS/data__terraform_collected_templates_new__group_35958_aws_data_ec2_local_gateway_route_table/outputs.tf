
output "id" {
  description = "ID of the local gateway route table"
  value       = data.aws_ec2_local_gateway_route_table.this.id
}

output "local_gateway_id" {
  description = "ID of the Local Gateway"
  value       = data.aws_ec2_local_gateway_route_table.this.local_gateway_id
}

output "local_gateway_route_table_id" {
  description = "ID of the local gateway route table"
  value       = data.aws_ec2_local_gateway_route_table.this.local_gateway_route_table_id
}

output "outpost_arn" {
  description = "ARN of the Outpost"
  value       = data.aws_ec2_local_gateway_route_table.this.outpost_arn
}


output "state" {
  description = "State of the local gateway route table"
  value       = data.aws_ec2_local_gateway_route_table.this.state
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = data.aws_ec2_local_gateway_route_table.this.tags
}