resource "kubernetes_persistent_volume_claim" "data" {
  count = local.use_s3 ? 0 : 1

  metadata {
    name      = "registry-data"
    namespace = kubernetes_namespace.registry.metadata[0].name
  }

  lifecycle {
    prevent_destroy = true
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = var.storage_size
      }
    }

    storage_class_name = null
  }
}
