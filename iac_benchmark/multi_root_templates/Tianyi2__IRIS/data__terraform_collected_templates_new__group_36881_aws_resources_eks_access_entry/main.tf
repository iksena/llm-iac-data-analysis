resource "aws_eks_access_entry" "this" {
  cluster_name      = var.cluster_name
  principal_arn     = var.principal_arn
  region            = var.region
  kubernetes_groups = var.kubernetes_groups
  tags              = var.tags
  type              = var.type
  user_name         = var.user_name

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}