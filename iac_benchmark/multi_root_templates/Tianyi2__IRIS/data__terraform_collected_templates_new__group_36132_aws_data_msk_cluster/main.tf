data "aws_msk_cluster" "this" {
  region       = var.region
  cluster_name = var.cluster_name
}