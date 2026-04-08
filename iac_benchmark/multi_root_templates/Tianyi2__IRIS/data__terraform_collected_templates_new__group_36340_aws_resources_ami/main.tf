resource "aws_ami" "this" {
  region              = var.region
  name                = var.name
  boot_mode           = var.boot_mode
  deprecation_time    = var.deprecation_time
  description         = var.description
  ena_support         = var.ena_support
  root_device_name    = var.root_device_name
  virtualization_type = var.virtualization_type
  architecture        = var.architecture
  tags                = var.tags
  tpm_support         = var.tpm_support
  imds_support        = var.imds_support
  uefi_data           = var.uefi_data

  # Paravirtual specific arguments
  image_location = var.image_location
  kernel_id      = var.kernel_id
  ramdisk_id     = var.ramdisk_id

  # HVM specific arguments  
  sriov_net_support = var.sriov_net_support

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
      iops                  = ebs_block_device.value.iops
      snapshot_id           = ebs_block_device.value.snapshot_id
      throughput            = ebs_block_device.value.throughput
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      outpost_arn           = ebs_block_device.value.outpost_arn
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_devices
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }
}