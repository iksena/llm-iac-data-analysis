resource "aws_msk_cluster_policy" "this" {
  cluster_arn = var.cluster_arn
  policy      = var.policy
  region      = var.region
}