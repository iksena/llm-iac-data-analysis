# module "openebs" {
#   count = var.openebs_enabled ? 1 : 0
#   source = "../openebs"

#   chart_cleanup_on_fail   = var.chart_cleanup_on_fail
#   chart_dependency_update = var.chart_dependency_update
#   chart_linting_enabled   = var.chart_linting_enabled
#   chart_recreate_pods     = var.chart_recreate_pods
#   chart_replace           = var.chart_replace
#   chart_upgrade_install   = var.chart_upgrade_install

#   namespace               = data.kubernetes_namespace.openebs[0].metadata[0].name
#   create_namespace        = false
# }
