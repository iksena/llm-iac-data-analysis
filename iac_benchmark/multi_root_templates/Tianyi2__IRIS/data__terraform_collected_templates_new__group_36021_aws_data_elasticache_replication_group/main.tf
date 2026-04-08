data "aws_elasticache_replication_group" "this" {
  region               = var.region
  replication_group_id = var.replication_group_id
}