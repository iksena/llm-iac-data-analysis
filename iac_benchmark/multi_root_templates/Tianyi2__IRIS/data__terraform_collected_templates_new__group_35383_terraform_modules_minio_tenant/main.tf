resource "helm_release" "application" {
  depends_on = [
    data.kubernetes_namespace.namespace,
  ]

  name       = local.chart_install_name
  repository = local.repository
  chart      = local.chart_reference
  version    = var.chart_version

  namespace        = data.kubernetes_namespace.namespace.metadata[0].name
  create_namespace = false

  dependency_update = var.chart_dependency_update
  lint              = var.chart_linting_enabled
  recreate_pods     = var.chart_recreate_pods
  upgrade_install   = var.chart_upgrade_install
  replace           = var.chart_replace
  cleanup_on_fail   = var.chart_cleanup_on_fail

  set =concat(
    [
      {
        name  = "tenant.name"
        value = local.chart_install_name
      },
      {
        name  = "tenant.configSecret.name"
        value = kubernetes_secret.password_secret.metadata[0].name
      },
      {
        name  = "tenant.configSecret.existingSecret"
        value = "true"
      },
      {
        name  = "tenant.pools[0].name"
        value = var.pool_name
      },
      {
        name  = "tenant.pools[0].size"
        value = "${var.pool_size_gb}Gi"
      },
      {
        name  = "tenant.pools[0].storageClassName"
        value = var.pool_storage_class_name
      },
      {
        name  = "tenant.pools[0].servers"
        value = tostring(var.pool_server_count)
      },
      {
        name  = "tenant.pools[0].volumesPerServer"
        value = tostring(var.pool_volume_count)
      },
      {
        name  = "tenant.pools[0].securityContext.runAsUser"
        value = tostring(var.pool_user_id)
      },
      {
        name  = "tenant.pools[0].securityContext.runAsGroup"
        value = tostring(var.pool_group_id)
      },
      {
        name  = "tenant.pools[0].securityContext.fsGroup"
        value = tostring(var.pool_group_id)
      },
      {
        name  = "tenant.pools[0].securityContext.fsGroupChangePolicy"
        value = "OnRootMismatch"
      },
      {
        name  = "tenant.pools[0].securityContext.runAsNonRoot"
        value = var.pool_user_id != 0 ? "true" : "false"
      },
      {
        name  = "tenant.pools[0].containerSecurityContext.runAsUser"
        value = tostring(var.pool_user_id)
      },
      {
        name  = "tenant.pools[0].containerSecurityContext.runAsGroup"
        value = tostring(var.pool_group_id)
      },
      {
        name  = "tenant.pools[0].containerSecurityContext.runAsNonRoot"
        value = var.pool_user_id != 0 ? "true" : "false"
      },
      {
        name  = "tenant.certificate.requestAutoCert"
        value = var.request_auto_cert ? "true" : "false"
      }
    ],
    [
      for k, v in var.pool_node_selector : {
        name  = "tenant.pools[0].nodeSelector.${replace(k, ".", "\\.")}"
        value = tostring(v)
      }
    ],
  )
  values = [
    yamlencode(
      {
        tenant = {
          buckets = var.buckets
          pools   = [
            {
              tolerations = var.pool_tolerations
            }
          ]
        }
      }
    )
  ]
}
