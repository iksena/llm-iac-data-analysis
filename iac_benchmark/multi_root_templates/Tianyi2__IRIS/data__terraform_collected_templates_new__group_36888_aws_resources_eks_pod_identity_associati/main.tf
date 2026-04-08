resource "aws_eks_pod_identity_association" "this" {
  cluster_name         = var.cluster_name
  namespace            = var.namespace
  role_arn             = var.role_arn
  service_account      = var.service_account
  disable_session_tags = var.disable_session_tags
  region               = var.region
  tags                 = var.tags
  target_role_arn      = var.target_role_arn
}