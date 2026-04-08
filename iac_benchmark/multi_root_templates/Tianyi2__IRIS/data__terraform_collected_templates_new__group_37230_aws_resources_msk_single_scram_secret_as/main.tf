resource "aws_msk_single_scram_secret_association" "this" {
  region      = var.region
  cluster_arn = var.cluster_arn
  secret_arn  = var.secret_arn
}