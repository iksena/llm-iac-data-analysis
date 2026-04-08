data "aws_eks_access_entry" "this" {
  region        = var.region
  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn
}