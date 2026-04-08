output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_local_gateway_virtual_interface_group.this.region
}

output "filter" {
  description = "Configuration blocks containing name-values filters."
  value       = data.aws_ec2_local_gateway_virtual_interface_group.this.filter
}

output "id" {
  description = "Identifier of EC2 Local Gateway Virtual Interface Group."
  value       = data.aws_ec2_local_gateway_virtual_interface_group.this.id
}

output "local_gateway_id" {
  description = "Identifier of EC2 Local Gateway."
  value       = data.aws_ec2_local_gateway_virtual_interface_group.this.local_gateway_id
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = data.aws_ec2_local_gateway_virtual_interface_group.this.tags
}

output "local_gateway_virtual_interface_ids" {
  description = "Set of EC2 Local Gateway Virtual Interface identifiers."
  value       = data.aws_ec2_local_gateway_virtual_interface_group.this.local_gateway_virtual_interface_ids
}