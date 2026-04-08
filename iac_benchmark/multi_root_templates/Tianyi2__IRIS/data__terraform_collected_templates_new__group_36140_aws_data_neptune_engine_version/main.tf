data "aws_neptune_engine_version" "this" {
  default_only              = var.default_only
  engine                    = var.engine
  has_major_target          = var.has_major_target
  has_minor_target          = var.has_minor_target
  latest                    = var.latest
  parameter_group_family    = var.parameter_group_family
  preferred_major_targets   = var.preferred_major_targets
  preferred_upgrade_targets = var.preferred_upgrade_targets
  preferred_versions        = var.preferred_versions
  region                    = var.region
  version                   = var.engine_version
}