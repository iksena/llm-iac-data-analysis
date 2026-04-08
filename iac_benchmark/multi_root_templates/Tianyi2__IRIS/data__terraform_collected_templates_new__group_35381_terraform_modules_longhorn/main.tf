resource "helm_release" "application" {
  depends_on = [
    data.kubernetes_namespace.namespace
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

  set = concat(
    [
      {
        name  = "defaultSettings.defaultDataPath"
        value = var.storage_default_path
      },
      {
        name  = "persistence.defaultClassReplicaCount"
        value = tostring(var.storage_replica_count)
      },
      {
        name  = "defaultSettings.defaultLonghornStaticStorageClass"
        value = var.storage_class_name
      },
      {
        name  = "persistence.reclaimPolicy"
        value = var.storage_reclaim_policy
      },
      {
        name  = "ingress.enabled"
        value = tostring(var.ingress_enabled)
      },
      {
        name  = "ingress.ingressClassName"
        value = var.ingress_class_name
      },
      {
        name  = "ingress.host"
        value = var.ingress_host_address
      },
      {
        name  = "ingress.path"
        value = local.ingress_path
      },
      {
        name  = "ingress.pathType"
        value = "ImplementationSpecific"
      },
      {
        name  = "ingress.tls"
        value = tostring(var.ingress_tls_enabled)
      },
      {
        name  = "ingress.tlsSecret"
        value = local.ingress_tls_secret_name
      },
      {
        name  = "service.ui.type"
        value = var.service_type
      }
    ],
    [
      for k, v in var.ingress_annotations:
      {
        name  = "ingress.annotations.${replace(k, ".", "\\.")}"
        value = tostring(v)
      }
    ]
  )
}
