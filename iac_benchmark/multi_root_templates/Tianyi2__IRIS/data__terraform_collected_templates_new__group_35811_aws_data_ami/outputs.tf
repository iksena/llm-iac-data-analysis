output "id" {
  description = "ID of the AMI."
  value       = data.aws_ami.this.id
}

output "arn" {
  description = "ARN of the AMI."
  value       = data.aws_ami.this.arn
}

output "architecture" {
  description = "OS architecture of the AMI (ie: i386 or x86_64)."
  value       = data.aws_ami.this.architecture
}

output "boot_mode" {
  description = "Boot mode of the image."
  value       = data.aws_ami.this.boot_mode
}

output "block_device_mappings" {
  description = "Set of objects with block device mappings of the AMI."
  value       = data.aws_ami.this.block_device_mappings
}

output "creation_date" {
  description = "Date and time the image was created."
  value       = data.aws_ami.this.creation_date
}

output "deprecation_time" {
  description = "Date and time when the image will be deprecated."
  value       = data.aws_ami.this.deprecation_time
}

output "description" {
  description = "Description of the AMI that was provided during image creation."
  value       = data.aws_ami.this.description
}

output "hypervisor" {
  description = "Hypervisor type of the image."
  value       = data.aws_ami.this.hypervisor
}

output "image_id" {
  description = "ID of the AMI. Should be the same as the resource id."
  value       = data.aws_ami.this.image_id
}

output "image_location" {
  description = "Location of the AMI."
  value       = data.aws_ami.this.image_location
}

output "image_owner_alias" {
  description = "AWS account alias (for example, amazon, self) or the AWS account ID of the AMI owner."
  value       = data.aws_ami.this.image_owner_alias
}

output "image_type" {
  description = "Type of image."
  value       = data.aws_ami.this.image_type
}

output "imds_support" {
  description = "Instance Metadata Service (IMDS) support mode for the image. Set to v2.0 if instances ran from this image enforce IMDSv2."
  value       = data.aws_ami.this.imds_support
}

output "kernel_id" {
  description = "Kernel associated with the image, if any. Only applicable for machine images."
  value       = data.aws_ami.this.kernel_id
}

output "last_launched_time" {
  description = "Date and time, in ISO 8601 date-time format, when the AMI was last used to launch an EC2 instance."
  value       = data.aws_ami.this.last_launched_time
}

output "name" {
  description = "Name of the AMI that was provided during image creation."
  value       = data.aws_ami.this.name
}

output "owner_id" {
  description = "AWS account ID of the image owner."
  value       = data.aws_ami.this.owner_id
}

output "platform" {
  description = "Value is Windows for Windows AMIs; otherwise blank."
  value       = data.aws_ami.this.platform
}

output "product_codes" {
  description = "Any product codes associated with the AMI."
  value       = data.aws_ami.this.product_codes
}

output "public" {
  description = "true if the image has public launch permissions."
  value       = data.aws_ami.this.public
}

output "ramdisk_id" {
  description = "RAM disk associated with the image, if any. Only applicable for machine images."
  value       = data.aws_ami.this.ramdisk_id
}

output "root_device_name" {
  description = "Device name of the root device."
  value       = data.aws_ami.this.root_device_name
}

output "root_device_type" {
  description = "Type of root device (ie: ebs or instance-store)."
  value       = data.aws_ami.this.root_device_type
}

output "root_snapshot_id" {
  description = "Snapshot id associated with the root device, if any (only applies to ebs root devices)."
  value       = data.aws_ami.this.root_snapshot_id
}

output "sriov_net_support" {
  description = "Whether enhanced networking is enabled."
  value       = data.aws_ami.this.sriov_net_support
}

output "state" {
  description = "Current state of the AMI. If the state is available, the image is successfully registered and can be used to launch an instance."
  value       = data.aws_ami.this.state
}

output "state_reason" {
  description = "Describes a state change. Fields are UNSET if not available."
  value       = data.aws_ami.this.state_reason
}

output "tags" {
  description = "Any tags assigned to the image."
  value       = data.aws_ami.this.tags
}

output "tpm_support" {
  description = "If the image is configured for NitroTPM support, the value is v2.0."
  value       = data.aws_ami.this.tpm_support
}

output "virtualization_type" {
  description = "Type of virtualization of the AMI (ie: hvm or paravirtual)."
  value       = data.aws_ami.this.virtualization_type
}

output "uefi_data" {
  description = "Base64 representation of the non-volatile UEFI variable store."
  value       = data.aws_ami.this.uefi_data
}

output "usage_operation" {
  description = "Operation of the Amazon EC2 instance and the billing code that is associated with the AMI."
  value       = data.aws_ami.this.usage_operation
}

output "platform_details" {
  description = "Platform details associated with the billing code of the AMI."
  value       = data.aws_ami.this.platform_details
}

output "ena_support" {
  description = "Whether enhanced networking with ENA is enabled."
  value       = data.aws_ami.this.ena_support
}