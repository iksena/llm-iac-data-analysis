resource "kubernetes_persistent_volume_claim" "wp_content" {
  metadata {
    name      = "wordpress-content"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
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
  }
}
