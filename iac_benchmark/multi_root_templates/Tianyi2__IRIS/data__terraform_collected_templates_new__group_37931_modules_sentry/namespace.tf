resource "kubernetes_namespace" "sentry" {
  metadata {
    name = var.namespace
    labels = {
      app = "sentry"
    }
  }
}
