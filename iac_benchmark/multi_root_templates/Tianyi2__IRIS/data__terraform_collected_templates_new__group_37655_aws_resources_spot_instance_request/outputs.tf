# Spot Instance Request ID
output "id" {
  description = "The Spot Instance Request ID"
  value       = aws_spot_instance_request.this.id
}

# Tags
output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_spot_instance_request.this.tags_all
}

# Spot Instance Request specific attributes
output "spot_bid_status" {
  description = "The current bid status of the Spot Instance Request"
  value       = aws_spot_instance_request.this.spot_bid_status
}

output "spot_request_state" {
  description = "The current request state of the Spot Instance Request"
  value       = aws_spot_instance_request.this.spot_request_state
}

output "spot_instance_id" {
  description = "The Instance ID (if any) that is currently fulfilling the Spot Instance request"
  value       = aws_spot_instance_request.this.spot_instance_id
}

# Network attributes
output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = aws_spot_instance_request.this.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = aws_spot_instance_request.this.public_ip
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = aws_spot_instance_request.this.private_dns
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_spot_instance_request.this.private_ip
}

# Additional EC2 Instance attributes that are also available for spot instances
output "arn" {
  description = "The ARN of the instance"
  value       = aws_spot_instance_request.this.arn
}

output "instance_state" {
  description = "The state of the instance"
  value       = aws_spot_instance_request.this.instance_state
}

output "outpost_arn" {
  description = "The ARN of the Outpost the instance is assigned to"
  value       = aws_spot_instance_request.this.outpost_arn
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance"
  value       = aws_spot_instance_request.this.password_data
  sensitive   = true
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = aws_spot_instance_request.this.primary_network_interface_id
}

output "private_dns_name_options" {
  description = "The options for the instance hostname"
  value       = aws_spot_instance_request.this.private_dns_name_options
}

output "secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses assigned to the instance's primary network interface"
  value       = aws_spot_instance_request.this.secondary_private_ips
}

output "security_groups" {
  description = "The associated security groups in non-VPC environments"
  value       = aws_spot_instance_request.this.security_groups
}

output "vpc_security_group_ids" {
  description = "The associated security groups in VPC environments"
  value       = aws_spot_instance_request.this.vpc_security_group_ids
}

output "subnet_id" {
  description = "The VPC subnet ID"
  value       = aws_spot_instance_request.this.subnet_id
}

output "tenancy" {
  description = "The tenancy of the instance"
  value       = aws_spot_instance_request.this.tenancy
}

output "user_data" {
  description = "The user data"
  value       = aws_spot_instance_request.this.user_data
}

output "user_data_base64" {
  description = "The base64-encoded user data"
  value       = aws_spot_instance_request.this.user_data_base64
}

output "host_id" {
  description = "The Id of the dedicated host the instance is assigned to"
  value       = aws_spot_instance_request.this.host_id
}

output "host_resource_group_arn" {
  description = "The ARN of the host resource group the instance is associated with"
  value       = aws_spot_instance_request.this.host_resource_group_arn
}

output "iam_instance_profile" {
  description = "The name of the instance profile associated with the instance"
  value       = aws_spot_instance_request.this.iam_instance_profile
}

output "ipv6_addresses" {
  description = "The IPv6 address"
  value       = aws_spot_instance_request.this.ipv6_addresses
}

output "key_name" {
  description = "The key name of the instance"
  value       = aws_spot_instance_request.this.key_name
}

output "monitoring" {
  description = "Whether detailed monitoring is enabled"
  value       = aws_spot_instance_request.this.monitoring
}

output "placement_group" {
  description = "The placement group of the instance"
  value       = aws_spot_instance_request.this.placement_group
}

output "placement_partition_number" {
  description = "The number of the partition the instance is in"
  value       = aws_spot_instance_request.this.placement_partition_number
}

output "root_block_device" {
  description = "Root block device information"
  value       = aws_spot_instance_request.this.root_block_device
}

output "ebs_block_device" {
  description = "EBS block device information"
  value       = aws_spot_instance_request.this.ebs_block_device
}

output "ephemeral_block_device" {
  description = "Ephemeral block device information"
  value       = aws_spot_instance_request.this.ephemeral_block_device
}

output "network_interface" {
  description = "Network interface information"
  value       = aws_spot_instance_request.this.network_interface
}