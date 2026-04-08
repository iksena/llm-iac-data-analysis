resource "kubernetes_persistent_volume_claim" "analytics_data" {
  metadata {
    name      = "analytics-data"
    namespace = kubernetes_namespace.analytics.metadata[0].name
    labels = {
      app = "analytics"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class_name != "" ? var.storage_class_name : null
  }
}
