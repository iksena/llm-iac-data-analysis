resource "aws_cloudhsm_v2_cluster" "this" {
  hsm_type                 = var.hsm_type
  subnet_ids               = var.subnet_ids
  source_backup_identifier = var.source_backup_identifier
  mode                     = var.mode
  tags                     = var.tags
}