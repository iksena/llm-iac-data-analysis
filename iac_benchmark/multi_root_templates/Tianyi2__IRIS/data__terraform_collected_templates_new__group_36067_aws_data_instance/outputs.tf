output "id" {
  description = "ID of the found Instance."
  value       = data.aws_instance.this.id
}

output "ami" {
  description = "ID of the AMI used to launch the instance."
  value       = data.aws_instance.this.ami
}

output "arn" {
  description = "ARN of the instance."
  value       = data.aws_instance.this.arn
}

output "associate_public_ip_address" {
  description = "Whether or not the Instance is associated with a public IP address or not (Boolean)."
  value       = data.aws_instance.this.associate_public_ip_address
}

output "availability_zone" {
  description = "Availability zone of the Instance."
  value       = data.aws_instance.this.availability_zone
}

output "credit_specification" {
  description = "Credit specification of the Instance."
  value       = data.aws_instance.this.credit_specification
}

output "disable_api_stop" {
  description = "Whether or not EC2 Instance Stop Protection is enabled (Boolean)."
  value       = data.aws_instance.this.disable_api_stop
}

output "disable_api_termination" {
  description = "Whether or not EC2 Instance Termination Protection is enabled (Boolean)."
  value       = data.aws_instance.this.disable_api_termination
}

output "ebs_block_device" {
  description = "EBS block device mappings of the Instance."
  value       = data.aws_instance.this.ebs_block_device
}

output "ebs_optimized" {
  description = "Whether the Instance is EBS optimized or not (Boolean)."
  value       = data.aws_instance.this.ebs_optimized
}

output "enclave_options" {
  description = "Enclave options of the instance."
  value       = data.aws_instance.this.enclave_options
}

output "ephemeral_block_device" {
  description = "Ephemeral block device mappings of the Instance."
  value       = data.aws_instance.this.ephemeral_block_device
}

output "host_id" {
  description = "ID of the dedicated host the instance will be assigned to."
  value       = data.aws_instance.this.host_id
}

output "host_resource_group_arn" {
  description = "ARN of the host resource group the instance is associated with."
  value       = data.aws_instance.this.host_resource_group_arn
}

output "iam_instance_profile" {
  description = "Name of the instance profile associated with the Instance."
  value       = data.aws_instance.this.iam_instance_profile
}

output "instance_state" {
  description = "State of the instance. One of: pending, running, shutting-down, terminated, stopping, stopped."
  value       = data.aws_instance.this.instance_state
}

output "instance_type" {
  description = "Type of the Instance."
  value       = data.aws_instance.this.instance_type
}

output "ipv6_addresses" {
  description = "IPv6 addresses associated to the Instance, if applicable."
  value       = data.aws_instance.this.ipv6_addresses
}

output "key_name" {
  description = "Key name of the Instance."
  value       = data.aws_instance.this.key_name
}

output "launch_time" {
  description = "Time the instance was launched."
  value       = data.aws_instance.this.launch_time
}

output "maintenance_options" {
  description = "Maintenance and recovery options for the instance."
  value       = data.aws_instance.this.maintenance_options
}

output "metadata_options" {
  description = "Metadata options of the Instance."
  value       = data.aws_instance.this.metadata_options
}

output "monitoring" {
  description = "Whether detailed monitoring is enabled or disabled for the Instance (Boolean)."
  value       = data.aws_instance.this.monitoring
}

output "network_interface_id" {
  description = "ID of the network interface that was created with the Instance."
  value       = data.aws_instance.this.network_interface_id
}

output "outpost_arn" {
  description = "ARN of the Outpost."
  value       = data.aws_instance.this.outpost_arn
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance. Useful for getting the administrator password for instances running Microsoft Windows."
  value       = data.aws_instance.this.password_data
  sensitive   = true
}

output "placement_group" {
  description = "Placement group of the Instance."
  value       = data.aws_instance.this.placement_group
}

output "placement_group_id" {
  description = "Placement group ID of the Instance."
  value       = data.aws_instance.this.placement_group_id
}

output "placement_partition_number" {
  description = "Number of the partition the instance is in."
  value       = data.aws_instance.this.placement_partition_number
}

output "private_dns" {
  description = "Private DNS name assigned to the Instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC."
  value       = data.aws_instance.this.private_dns
}

output "private_dns_name_options" {
  description = "Options for the instance hostname."
  value       = data.aws_instance.this.private_dns_name_options
}

output "private_ip" {
  description = "Private IP address assigned to the Instance."
  value       = data.aws_instance.this.private_ip
}

output "public_dns" {
  description = "Public DNS name assigned to the Instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
  value       = data.aws_instance.this.public_dns
}

output "public_ip" {
  description = "Public IP address assigned to the Instance, if applicable."
  value       = data.aws_instance.this.public_ip
}

output "root_block_device" {
  description = "Root block device mappings of the Instance."
  value       = data.aws_instance.this.root_block_device
}

output "secondary_private_ips" {
  description = "Secondary private IPv4 addresses assigned to the instance's primary network interface (eth0) in a VPC."
  value       = data.aws_instance.this.secondary_private_ips
}

output "security_groups" {
  description = "Associated security groups."
  value       = data.aws_instance.this.security_groups
}

output "source_dest_check" {
  description = "Whether the network interface performs source/destination checking (Boolean)."
  value       = data.aws_instance.this.source_dest_check
}

output "subnet_id" {
  description = "VPC subnet ID."
  value       = data.aws_instance.this.subnet_id
}

output "tags" {
  description = "Map of tags assigned to the Instance."
  value       = data.aws_instance.this.tags
}

output "tenancy" {
  description = "Tenancy of the instance: dedicated, default, host."
  value       = data.aws_instance.this.tenancy
}

output "user_data" {
  description = "SHA-1 hash of User Data supplied to the Instance."
  value       = data.aws_instance.this.user_data
}

output "user_data_base64" {
  description = "Base64 encoded contents of User Data supplied to the Instance. Valid UTF-8 contents can be decoded with the base64decode function."
  value       = data.aws_instance.this.user_data_base64
  sensitive   = true
}

output "vpc_security_group_ids" {
  description = "Associated security groups in a non-default VPC."
  value       = data.aws_instance.this.vpc_security_group_ids
}