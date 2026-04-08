output "region" {
  description = "Region where this resource is managed."
  value       = aws_network_interface_permission.this.region
}

output "network_interface_id" {
  description = "The ID of the network interface."
  value       = aws_network_interface_permission.this.network_interface_id
}

output "aws_account_id" {
  description = "The Amazon Web Services account ID."
  value       = aws_network_interface_permission.this.aws_account_id
}

output "permission" {
  description = "The type of permission granted."
  value       = aws_network_interface_permission.this.permission
}

output "network_interface_permission_id" {
  description = "ENI permission ID."
  value       = aws_network_interface_permission.this.network_interface_permission_id
}