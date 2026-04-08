output "id" {
  description = "AWS Region."
  value       = data.aws_ec2_local_gateway_virtual_interface_groups.this.id
}

output "ids" {
  description = "Set of EC2 Local Gateway Virtual Interface Group identifiers."
  value       = data.aws_ec2_local_gateway_virtual_interface_groups.this.ids
}

output "local_gateway_virtual_interface_ids" {
  description = "Set of EC2 Local Gateway Virtual Interface identifiers."
  value       = data.aws_ec2_local_gateway_virtual_interface_groups.this.local_gateway_virtual_interface_ids
}