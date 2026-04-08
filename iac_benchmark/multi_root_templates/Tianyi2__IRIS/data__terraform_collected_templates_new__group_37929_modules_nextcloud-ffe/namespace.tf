resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"    = "nextcloud"
      "app.kubernetes.io/part-of" = "apps"
    }
  }
}
