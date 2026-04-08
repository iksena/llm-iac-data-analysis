module "longhorn" {
  source = "../longhorn"

  namespace               = data.kubernetes_namespace.longhorn.metadata[0].name
  create_namespace        = false

  chart_cleanup_on_fail   = var.chart_cleanup_on_fail
  chart_dependency_update = var.chart_dependency_update
  chart_linting_enabled   = var.chart_linting_enabled
  chart_recreate_pods     = var.chart_recreate_pods
  chart_replace           = var.chart_replace
  chart_upgrade_install   = var.chart_upgrade_install
  chart_version           = var.longhorn_version

  ingress_enabled      = var.longhorn_ingress_enabled
  ingress_class_name = var.longhorn_ingress_class_name
  ingress_host_address = var.longhorn_ingress_host_address
  ingress_tls_enabled = var.longhorn_ingress_tls_enabled
  ingress_annotations    = var.longhorn_ingress_annotations

  storage_replica_count = var.longhorn_storage_replica_count
  storage_class_name      = var.longhorn_storage_class_name
  storage_reclaim_policy = var.longhorn_storage_reclaim_policy
  storage_default_path = var.longhorn_storage_default_path
}
