resource "aws_eks_fargate_profile" "this" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = var.pod_execution_role_arn
  subnet_ids             = var.subnet_ids
  region                 = var.region
  tags                   = var.tags

  dynamic "selector" {
    for_each = var.selector
    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}