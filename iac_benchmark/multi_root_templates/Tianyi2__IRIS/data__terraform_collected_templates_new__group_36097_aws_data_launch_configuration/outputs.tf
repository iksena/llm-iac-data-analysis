output "id" {
  description = "ID of the launch configuration"
  value       = data.aws_launch_configuration.this.id
}

output "arn" {
  description = "Amazon Resource Name of the launch configuration"
  value       = data.aws_launch_configuration.this.arn
}

output "name" {
  description = "Name of the launch configuration"
  value       = data.aws_launch_configuration.this.name
}

output "image_id" {
  description = "EC2 Image ID of the instance"
  value       = data.aws_launch_configuration.this.image_id
}

output "instance_type" {
  description = "Instance Type of the instance to launch"
  value       = data.aws_launch_configuration.this.instance_type
}

output "iam_instance_profile" {
  description = "The IAM Instance Profile to associate with launched instances"
  value       = data.aws_launch_configuration.this.iam_instance_profile
}

output "key_name" {
  description = "Key Name that should be used for the instance"
  value       = data.aws_launch_configuration.this.key_name
}

output "metadata_options" {
  description = "Metadata options for the instance"
  value       = data.aws_launch_configuration.this.metadata_options
}

output "security_groups" {
  description = "List of associated Security Group IDS"
  value       = data.aws_launch_configuration.this.security_groups
}

output "associate_public_ip_address" {
  description = "Whether a Public IP address is associated with the instance"
  value       = data.aws_launch_configuration.this.associate_public_ip_address
}

output "user_data" {
  description = "User Data of the instance"
  value       = data.aws_launch_configuration.this.user_data
}

output "enable_monitoring" {
  description = "Whether Detailed Monitoring is Enabled"
  value       = data.aws_launch_configuration.this.enable_monitoring
}

output "ebs_optimized" {
  description = "Whether the launched EC2 instance will be EBS-optimized"
  value       = data.aws_launch_configuration.this.ebs_optimized
}

output "root_block_device" {
  description = "Root Block Device of the instance"
  value       = data.aws_launch_configuration.this.root_block_device
}

output "ebs_block_device" {
  description = "EBS Block Devices attached to the instance"
  value       = data.aws_launch_configuration.this.ebs_block_device
}

output "ephemeral_block_device" {
  description = "The Ephemeral volumes on the instance"
  value       = data.aws_launch_configuration.this.ephemeral_block_device
}

output "spot_price" {
  description = "Price to use for reserving Spot instances"
  value       = data.aws_launch_configuration.this.spot_price
}

output "placement_tenancy" {
  description = "Tenancy of the instance"
  value       = data.aws_launch_configuration.this.placement_tenancy
}