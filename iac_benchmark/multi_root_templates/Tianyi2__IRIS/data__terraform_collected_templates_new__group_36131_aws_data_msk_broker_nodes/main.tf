data "aws_msk_broker_nodes" "this" {
  cluster_arn = var.cluster_arn
  region      = var.region
}