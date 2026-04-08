resource "aws_eks_addon" "this" {
  addon_name                  = var.addon_name
  cluster_name                = var.cluster_name
  addon_version               = var.addon_version
  configuration_values        = var.configuration_values
  resolve_conflicts_on_create = var.resolve_conflicts_on_create
  resolve_conflicts_on_update = var.resolve_conflicts_on_update
  tags                        = var.tags
  preserve                    = var.preserve
  service_account_role_arn    = var.service_account_role_arn

  dynamic "pod_identity_association" {
    for_each = var.pod_identity_association != null ? [var.pod_identity_association] : []
    content {
      role_arn        = pod_identity_association.value.role_arn
      service_account = pod_identity_association.value.service_account
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}