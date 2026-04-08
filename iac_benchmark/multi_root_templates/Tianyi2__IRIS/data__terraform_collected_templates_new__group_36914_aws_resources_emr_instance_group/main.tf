resource "aws_emr_instance_group" "this" {
  region              = var.region
  name                = var.name
  cluster_id          = var.cluster_id
  instance_type       = var.instance_type
  instance_count      = var.instance_count
  bid_price           = var.bid_price
  ebs_optimized       = var.ebs_optimized
  autoscaling_policy  = var.autoscaling_policy
  configurations_json = var.configurations_json

  dynamic "ebs_config" {
    for_each = var.ebs_config
    content {
      iops                 = ebs_config.value.iops
      size                 = ebs_config.value.size
      type                 = ebs_config.value.type
      volumes_per_instance = ebs_config.value.volumes_per_instance
    }
  }
}