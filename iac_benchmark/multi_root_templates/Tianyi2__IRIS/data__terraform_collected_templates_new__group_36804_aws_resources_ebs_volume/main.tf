resource "aws_ebs_volume" "this" {
  region                     = var.region
  availability_zone          = var.availability_zone
  encrypted                  = var.encrypted
  final_snapshot             = var.final_snapshot
  iops                       = var.iops
  kms_key_id                 = var.kms_key_id
  multi_attach_enabled       = var.multi_attach_enabled
  outpost_arn                = var.outpost_arn
  size                       = var.size
  snapshot_id                = var.snapshot_id
  tags                       = var.tags
  throughput                 = var.throughput
  type                       = var.type
  volume_initialization_rate = var.volume_initialization_rate

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}