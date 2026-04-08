data "aws_rds_cluster" "this" {
  cluster_identifier = var.cluster_identifier
  region             = var.region
}