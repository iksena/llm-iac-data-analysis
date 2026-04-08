resource "aws_rds_shard_group" "this" {
  region                    = var.region
  compute_redundancy        = var.compute_redundancy
  db_cluster_identifier     = var.db_cluster_identifier
  db_shard_group_identifier = var.db_shard_group_identifier
  max_acu                   = var.max_acu
  min_acu                   = var.min_acu
  publicly_accessible       = var.publicly_accessible
  tags                      = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}