/*
  Nextcloud Helm release (ingress managed externally in ingress.tf)
  - External Postgres
  - PVC for data
*/
resource "helm_release" "nextcloud" {
  name      = "nextcloud"
  namespace = kubernetes_namespace.nextcloud.metadata[0].name

  repository      = "https://nextcloud.github.io/helm/"
  chart           = "nextcloud"
  version         = var.chart_version != "" ? var.chart_version : null
  cleanup_on_fail = true
  atomic          = true

  set = [
    { name = "ingress.enabled", value = false },
    { name = "internalDatabase.enabled", value = false },
    { name = "externalDatabase.enabled", value = true },
    { name = "externalDatabase.type", value = "postgresql" },
    { name = "externalDatabase.host", value = var.db_host },
    { name = "externalDatabase.port", value = var.db_port },
    { name = "externalDatabase.database", value = var.db_name },
    { name = "externalDatabase.user", value = var.db_user },
    { name = "persistence.enabled", value = true },
    { name = "persistence.size", value = var.storage_size },
    { name = "replicaCount", value = var.replicas },
    { name = "resources.requests.cpu", value = "250m" },
    { name = "resources.limits.cpu", value = "500m" },
    { name = "resources.limits.memory", value = "1Gi" },
    // Prometheus metrics via built-in exporter + ServiceMonitor
    { name = "metrics.enabled", value = true },
    { name = "metrics.serviceMonitor.enabled", value = true },
    { name = "metrics.serviceMonitor.labels.release", value = "prometheus" }
  ]

  set_sensitive = [
    {
      name  = "externalDatabase.password"
      value = var.db_password
    }
  ]
}
