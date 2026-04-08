resource "kubernetes_namespace" "analytics" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"    = "analytics"
      "app.kubernetes.io/part-of" = "apps"
    }
  }
}
