data "aws_rds_engine_version" "this" {
  engine                    = var.engine
  region                    = var.region
  default_only              = var.default_only
  has_major_target          = var.has_major_target
  has_minor_target          = var.has_minor_target
  include_all               = var.include_all
  latest                    = var.latest
  parameter_group_family    = var.parameter_group_family
  preferred_major_targets   = var.preferred_major_targets
  preferred_upgrade_targets = var.preferred_upgrade_targets
  preferred_versions        = var.preferred_versions
  version                   = var.engine_version

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}