# Validation to ensure exactly one of instance_family or instance_type is specified
locals {
  instance_config_count = (
    (var.instance_family != null ? 1 : 0) +
    (var.instance_type != null ? 1 : 0)
  )
}

check "instance_config_validation" {
  assert {
    condition     = local.instance_config_count == 1
    error_message = "resource_aws_ec2_host: instance_family and instance_type are mutually exclusive - exactly one must be specified."
  }
}

resource "aws_ec2_host" "this" {
  region            = var.region
  asset_id          = var.asset_id
  auto_placement    = var.auto_placement
  availability_zone = var.availability_zone
  host_recovery     = var.host_recovery
  instance_family   = var.instance_family
  instance_type     = var.instance_type
  outpost_arn       = var.outpost_arn
  tags              = var.tags

  timeouts {
    create = "10m"
    update = "10m"
    delete = "20m"
  }
}