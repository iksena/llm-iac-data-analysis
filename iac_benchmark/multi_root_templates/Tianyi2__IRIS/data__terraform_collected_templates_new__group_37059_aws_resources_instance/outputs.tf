output "arn" {
  description = "ARN of the instance."
  value       = aws_instance.this.arn
}

output "capacity_reservation_specification" {
  description = "Capacity reservation specification of the instance."
  value       = aws_instance.this.capacity_reservation_specification
}

output "id" {
  description = "ID of the instance."
  value       = aws_instance.this.id
}

output "instance_state" {
  description = "State of the instance. One of: pending, running, shutting-down, terminated, stopping, stopped."
  value       = aws_instance.this.instance_state
}

output "outpost_arn" {
  description = "ARN of the Outpost the instance is assigned to."
  value       = aws_instance.this.outpost_arn
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance. Useful for getting the administrator password for instances running Microsoft Windows."
  value       = aws_instance.this.password_data
  sensitive   = true
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface."
  value       = aws_instance.this.primary_network_interface_id
}

output "private_dns" {
  description = "Private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.this.private_dns
}

output "public_dns" {
  description = "Public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
  value       = aws_instance.this.public_dns
}

output "public_ip" {
  description = "Public IP address assigned to the instance, if applicable."
  value       = aws_instance.this.public_ip
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_instance.this.tags_all
}

output "ebs_block_device" {
  description = "EBS block devices attached to the instance."
  value       = aws_instance.this.ebs_block_device
}

output "root_block_device" {
  description = "Root block device attached to the instance."
  value       = aws_instance.this.root_block_device
}

output "instance_market_options" {
  description = "Instance market options including lifecycle and spot instance request ID."
  value       = aws_instance.this.instance_market_options
}