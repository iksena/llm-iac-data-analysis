resource "aws_memorydb_snapshot" "this" {
  region       = var.region
  cluster_name = var.cluster_name
  name         = var.name
  name_prefix  = var.name_prefix
  kms_key_arn  = var.kms_key_arn
  tags         = var.tags

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}