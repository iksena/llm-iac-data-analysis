data "aws_msk_bootstrap_brokers" "this" {
  region      = var.region
  cluster_arn = var.cluster_arn
}