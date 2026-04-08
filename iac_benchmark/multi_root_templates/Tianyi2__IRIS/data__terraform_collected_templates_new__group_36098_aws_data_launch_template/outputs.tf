output "id" {
  description = "ID of the launch template."
  value       = data.aws_launch_template.this.id
}

output "name" {
  description = "Name of the launch template."
  value       = data.aws_launch_template.this.name
}

output "region" {
  description = "Region where the launch template is managed."
  value       = data.aws_launch_template.this.region
}

output "tags" {
  description = "Map of tags assigned to the launch template."
  value       = data.aws_launch_template.this.tags
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the launch template."
  value       = data.aws_launch_template.this.arn
}

output "default_version" {
  description = "Default Version of the launch template."
  value       = data.aws_launch_template.this.default_version
}

output "latest_version" {
  description = "Latest Version of the launch template."
  value       = data.aws_launch_template.this.latest_version
}

output "description" {
  description = "Description of the launch template."
  value       = data.aws_launch_template.this.description
}

output "image_id" {
  description = "AMI from which to launch the instance."
  value       = data.aws_launch_template.this.image_id
}

output "instance_type" {
  description = "Type of the instance."
  value       = data.aws_launch_template.this.instance_type
}

output "key_name" {
  description = "Key name that should be used for the instance."
  value       = data.aws_launch_template.this.key_name
}

output "vpc_security_group_ids" {
  description = "List of security group IDs to associate."
  value       = data.aws_launch_template.this.vpc_security_group_ids
}

output "user_data" {
  description = "Base64-encoded user data to provide when launching the instance."
  value       = data.aws_launch_template.this.user_data
  sensitive   = true
}

output "block_device_mappings" {
  description = "Specification of the block device mappings."
  value       = data.aws_launch_template.this.block_device_mappings
}

output "capacity_reservation_specification" {
  description = "Targeting for EC2 capacity reservations."
  value       = data.aws_launch_template.this.capacity_reservation_specification
}

output "cpu_options" {
  description = "CPU options for the instance."
  value       = data.aws_launch_template.this.cpu_options
}

output "credit_specification" {
  description = "Credit specification of the instance."
  value       = data.aws_launch_template.this.credit_specification
}

output "disable_api_stop" {
  description = "Whether the instance is disabled for stop protection."
  value       = data.aws_launch_template.this.disable_api_stop
}

output "disable_api_termination" {
  description = "Whether the instance is disabled for termination protection."
  value       = data.aws_launch_template.this.disable_api_termination
}

output "ebs_optimized" {
  description = "Whether the instance is optimized for Amazon EBS I/O."
  value       = data.aws_launch_template.this.ebs_optimized
}


output "enclave_options" {
  description = "Enable Nitro Enclaves on launched instances."
  value       = data.aws_launch_template.this.enclave_options
}

output "hibernation_options" {
  description = "Hibernation options for the instance."
  value       = data.aws_launch_template.this.hibernation_options
}

output "iam_instance_profile" {
  description = "IAM Instance Profile specification."
  value       = data.aws_launch_template.this.iam_instance_profile
}

output "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance."
  value       = data.aws_launch_template.this.instance_initiated_shutdown_behavior
}

output "instance_market_options" {
  description = "Market (purchasing) option for the instances."
  value       = data.aws_launch_template.this.instance_market_options
}

output "instance_requirements" {
  description = "Instance requirements specification."
  value       = data.aws_launch_template.this.instance_requirements
}

output "kernel_id" {
  description = "Kernel ID."
  value       = data.aws_launch_template.this.kernel_id
}

output "license_specification" {
  description = "List of license specifications."
  value       = data.aws_launch_template.this.license_specification
}

output "maintenance_options" {
  description = "Maintenance options for the instance."
  value       = data.aws_launch_template.this.maintenance_options
}

output "metadata_options" {
  description = "Metadata options for the instance."
  value       = data.aws_launch_template.this.metadata_options
}

output "monitoring" {
  description = "Monitoring option for the instance."
  value       = data.aws_launch_template.this.monitoring
}

output "network_interfaces" {
  description = "Network interface specifications."
  value       = data.aws_launch_template.this.network_interfaces
}

output "placement" {
  description = "Placement of the instance."
  value       = data.aws_launch_template.this.placement
}

output "private_dns_name_options" {
  description = "Options for the instance hostname."
  value       = data.aws_launch_template.this.private_dns_name_options
}

output "ram_disk_id" {
  description = "RAM disk ID."
  value       = data.aws_launch_template.this.ram_disk_id
}

output "security_group_names" {
  description = "List of security group names."
  value       = data.aws_launch_template.this.security_group_names
}

output "tag_specifications" {
  description = "Tag specifications for resources created by the launch template."
  value       = data.aws_launch_template.this.tag_specifications
}