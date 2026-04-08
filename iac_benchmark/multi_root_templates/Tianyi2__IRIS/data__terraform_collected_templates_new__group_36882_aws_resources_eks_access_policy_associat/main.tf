resource "aws_eks_access_policy_association" "this" {
  region        = var.region
  cluster_name  = var.cluster_name
  policy_arn    = var.policy_arn
  principal_arn = var.principal_arn

  access_scope {
    type       = var.access_scope_type
    namespaces = var.access_scope_namespaces
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}