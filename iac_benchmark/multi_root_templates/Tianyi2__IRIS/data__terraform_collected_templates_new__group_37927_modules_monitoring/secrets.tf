/*
    Grafana admin credentials (used by kube-prometheus-stack chart via existingSecret)
*/
resource "kubernetes_secret" "grafana_admin" {
  count = var.enable_kube_prometheus_stack ? 1 : 0

  metadata {
    name      = "grafana-admin"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "admin-user"     = var.grafana_admin_user
    "admin-password" = var.grafana_admin_password
  }
}
