resource "aws_launch_configuration" "this" {
  region                      = var.region
  image_id                    = var.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  ebs_optimized               = var.ebs_optimized
  enable_monitoring           = var.enable_monitoring
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  name                        = var.name
  name_prefix                 = var.name_prefix
  security_groups             = var.security_groups
  placement_tenancy           = var.placement_tenancy
  spot_price                  = var.spot_price
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name           = ebs_block_device.value.device_name
      snapshot_id           = ebs_block_device.value.snapshot_id
      volume_type           = ebs_block_device.value.volume_type
      volume_size           = ebs_block_device.value.volume_size
      iops                  = ebs_block_device.value.iops
      throughput            = ebs_block_device.value.throughput
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
      no_device             = ebs_block_device.value.no_device
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = ephemeral_block_device.value.no_device
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device != null ? [var.root_block_device] : []
    content {
      delete_on_termination = root_block_device.value.delete_on_termination
      encrypted             = root_block_device.value.encrypted
      iops                  = root_block_device.value.iops
      throughput            = root_block_device.value.throughput
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = metadata_options.value.http_endpoint
      http_tokens                 = metadata_options.value.http_tokens
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
    }
  }
}