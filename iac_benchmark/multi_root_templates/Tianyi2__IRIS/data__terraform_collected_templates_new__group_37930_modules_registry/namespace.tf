resource "kubernetes_namespace" "registry" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"    = "registry"
      "app.kubernetes.io/part-of" = "infra"
    }
  }
}
