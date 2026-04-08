resource "aws_redshift_snapshot_schedule" "this" {
  region            = var.region
  identifier        = var.identifier
  identifier_prefix = var.identifier_prefix
  description       = var.description
  definitions       = var.definitions
  force_destroy     = var.force_destroy
  tags              = var.tags
}