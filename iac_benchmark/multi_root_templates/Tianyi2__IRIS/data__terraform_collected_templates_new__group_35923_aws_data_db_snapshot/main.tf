locals {
  # Validation: At least one identifier must be provided
  validate_identifiers = var.db_instance_identifier != null || var.db_snapshot_identifier != null ? true : tobool("Either db_instance_identifier or db_snapshot_identifier is required")
}

data "aws_db_snapshot" "this" {
  region                 = var.region
  most_recent            = var.most_recent
  db_instance_identifier = var.db_instance_identifier
  db_snapshot_identifier = var.db_snapshot_identifier
  snapshot_type          = var.snapshot_type
  include_shared         = var.include_shared
  include_public         = var.include_public
  tags                   = var.tags
}