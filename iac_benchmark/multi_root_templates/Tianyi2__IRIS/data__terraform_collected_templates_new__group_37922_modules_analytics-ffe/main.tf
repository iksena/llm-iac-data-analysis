locals {
  vince_scheme  = var.enable_tls ? "https" : "http"
  vince_baseurl = format("%s://%s", local.vince_scheme, var.host)
}

resource "kubernetes_secret" "vince_admin" {
  metadata {
    name      = "vince-admin"
    namespace = kubernetes_namespace.analytics.metadata[0].name
    labels = {
      app = "vince"
    }
  }

  data = {
    VINCE_ADMIN_NAME     = var.admin_username
    VINCE_ADMIN_PASSWORD = var.admin_password
  }
}

resource "kubernetes_deployment" "vince" {
  metadata {
    name      = "vince"
    namespace = kubernetes_namespace.analytics.metadata[0].name
    labels = {
      app = "vince"
    }
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "vince"
      }
    }

    template {
      metadata {
        labels = {
          app = "vince"
        }
      }

      spec {
        container {
          name  = "vince"
          image = var.vince_image
          args  = ["serve"]

          port {
            name           = "http"
            container_port = 8080
          }

          env {
            name  = "VINCE_URL"
            value = local.vince_baseurl
          }

          env {
            name  = "VINCE_DATA"
            value = "/data"
          }

          env {
            name  = "VINCE_DOMAINS"
            value = join(",", var.domains)
          }

          env {
            name = "VINCE_ADMIN_NAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.vince_admin.metadata[0].name
                key  = "VINCE_ADMIN_NAME"
              }
            }
          }

          env {
            name = "VINCE_ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.vince_admin.metadata[0].name
                key  = "VINCE_ADMIN_PASSWORD"
              }
            }
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "http"
            }
            initial_delay_seconds = 10
            period_seconds        = 15
            timeout_seconds       = 5
            failure_threshold     = 6
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "http"
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 6
          }

          volume_mount {
            name       = "analytics-data"
            mount_path = "/data"
          }

          volume_mount {
            name       = "vince-buffers"
            mount_path = "/data/buffers"
          }
        }

        volume {
          name = "analytics-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.analytics_data.metadata[0].name
          }
        }

        volume {
          name = "vince-buffers"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "vince" {
  metadata {
    name      = "vince"
    namespace = kubernetes_namespace.analytics.metadata[0].name
    labels = {
      app = "vince"
    }
  }

  spec {
    selector = {
      app = "vince"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8080
    }
  }
}
