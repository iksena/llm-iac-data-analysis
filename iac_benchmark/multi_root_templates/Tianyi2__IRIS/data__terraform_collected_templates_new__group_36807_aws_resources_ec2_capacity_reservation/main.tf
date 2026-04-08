resource "aws_ec2_capacity_reservation" "this" {
  availability_zone = var.availability_zone
  instance_count    = var.instance_count
  instance_platform = var.instance_platform
  instance_type     = var.instance_type

  ebs_optimized           = var.ebs_optimized
  end_date                = var.end_date
  end_date_type           = var.end_date_type
  ephemeral_storage       = var.ephemeral_storage
  instance_match_criteria = var.instance_match_criteria
  outpost_arn             = var.outpost_arn
  placement_group_arn     = var.placement_group_arn
  tags                    = var.tags
  tenancy                 = var.tenancy

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}