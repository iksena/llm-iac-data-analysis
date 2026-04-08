resource "kubernetes_namespace" "twenty" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"    = "twenty"
      "app.kubernetes.io/part-of" = "apps"
    }
  }
}
