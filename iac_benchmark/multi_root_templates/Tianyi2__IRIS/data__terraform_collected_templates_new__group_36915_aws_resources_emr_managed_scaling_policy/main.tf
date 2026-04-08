resource "aws_emr_managed_scaling_policy" "this" {
  cluster_id = var.cluster_id

  compute_limits {
    unit_type                       = var.compute_limits.unit_type
    minimum_capacity_units          = var.compute_limits.minimum_capacity_units
    maximum_capacity_units          = var.compute_limits.maximum_capacity_units
    maximum_ondemand_capacity_units = var.compute_limits.maximum_ondemand_capacity_units
    maximum_core_capacity_units     = var.compute_limits.maximum_core_capacity_units
  }
}