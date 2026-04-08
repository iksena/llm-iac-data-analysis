resource "aws_spot_instance_request" "this" {
  # Spot Instance Request specific arguments
  spot_price                     = var.spot_price
  wait_for_fulfillment           = var.wait_for_fulfillment
  spot_type                      = var.spot_type
  launch_group                   = var.launch_group
  instance_interruption_behavior = var.instance_interruption_behavior
  valid_until                    = var.valid_until
  valid_from                     = var.valid_from

  # Required EC2 Instance arguments
  ami           = var.ami
  instance_type = var.instance_type

  # Optional EC2 Instance arguments
  key_name                             = var.key_name
  associate_public_ip_address          = var.associate_public_ip_address
  subnet_id                            = var.subnet_id
  vpc_security_group_ids               = var.vpc_security_group_ids
  security_groups                      = var.security_groups
  monitoring                           = var.monitoring
  iam_instance_profile                 = var.iam_instance_profile
  ebs_optimized                        = var.ebs_optimized
  tenancy                              = var.tenancy
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  private_ip                           = var.private_ip
  source_dest_check                    = var.source_dest_check
  user_data                            = var.user_data
  volume_tags                          = var.volume_tags
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  availability_zone                    = var.availability_zone
  get_password_data                    = var.get_password_data

  # Block device configurations
  dynamic "root_block_device" {
    for_each = var.root_block_device != null ? [var.root_block_device] : []
    content {
      volume_type           = root_block_device.value.volume_type
      volume_size           = root_block_device.value.volume_size
      iops                  = root_block_device.value.iops
      throughput            = root_block_device.value.throughput
      delete_on_termination = root_block_device.value.delete_on_termination
      encrypted             = root_block_device.value.encrypted
      kms_key_id            = root_block_device.value.kms_key_id
      tags                  = root_block_device.value.tags
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name           = ebs_block_device.value.device_name
      volume_type           = ebs_block_device.value.volume_type
      volume_size           = ebs_block_device.value.volume_size
      iops                  = ebs_block_device.value.iops
      throughput            = ebs_block_device.value.throughput
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
      kms_key_id            = ebs_block_device.value.kms_key_id
      snapshot_id           = ebs_block_device.value.snapshot_id
      tags                  = ebs_block_device.value.tags
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
      no_device    = ephemeral_block_device.value.no_device
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      network_interface_id  = network_interface.value.network_interface_id
      device_index          = network_interface.value.device_index
      delete_on_termination = network_interface.value.delete_on_termination
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    delete = var.timeouts.delete
  }
}