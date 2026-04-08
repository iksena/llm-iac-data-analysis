data "aws_elasticache_cluster" "this" {
  cluster_id = var.cluster_id
  region     = var.region
}