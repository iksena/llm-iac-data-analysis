data "aws_docdb_engine_version" "this" {
  region                 = var.region
  engine                 = var.engine
  parameter_group_family = var.parameter_group_family
  preferred_versions     = var.preferred_versions
  version                = var.engine_version
}