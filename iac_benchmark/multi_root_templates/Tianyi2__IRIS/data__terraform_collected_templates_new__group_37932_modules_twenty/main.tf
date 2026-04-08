locals {
  service_port = 3000
  scheme       = var.enable_tls ? "https" : "http"
  server_url   = format("%s://%s", local.scheme, var.host)
  redis_host   = "twenty-redis"
  redis_url    = format("redis://%s:6379", local.redis_host)
}

resource "kubernetes_persistent_volume_claim" "twenty_data" {
  metadata {
    name      = "twenty-data"
    namespace = kubernetes_namespace.twenty.metadata[0].name
    labels = {
      app = "twenty"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "twenty" {
  metadata {
    name      = "twenty"
    namespace = kubernetes_namespace.twenty.metadata[0].name
    labels = {
      app = "twenty"
    }
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "twenty"
      }
    }

    template {
      metadata {
        labels = {
          app = "twenty"
        }
      }

      spec {
        security_context {
          run_as_user            = 1000
          run_as_group           = 1000
          fs_group               = 1000
          fs_group_change_policy = "OnRootMismatch"
          run_as_non_root        = true
        }

        volume {
          name = "local-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.twenty_data.metadata[0].name
          }
        }

        container {
          name  = "server"
          image = var.image

          port {
            name           = "http"
            container_port = local.service_port
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "800m"
              memory = "1Gi"
            }
          }

          env {
            name  = "NODE_PORT"
            value = tostring(local.service_port)
          }
          env {
            name = "PG_DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.twenty_env.metadata[0].name
                key  = "PG_DATABASE_URL"
              }
            }
          }
          env {
            name  = "SERVER_URL"
            value = local.server_url
          }
          env {
            name  = "REDIS_URL"
            value = local.redis_url
          }
          env {
            name = "APP_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.twenty_env.metadata[0].name
                key  = "APP_SECRET"
              }
            }
          }
          env {
            name  = "STORAGE_TYPE"
            value = "local"
          }
          env {
            name  = "LOCAL_STORAGE_PATH"
            value = "/app/packages/twenty-server/.local-storage"
          }
          env {
            name  = "NODE_OPTIONS"
            value = "--max-old-space-size=2048"
          }

          volume_mount {
            name       = "local-data"
            mount_path = "/app/packages/twenty-server/.local-storage"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }
            initial_delay_seconds = 300
            period_seconds        = 15
            timeout_seconds       = 5
            failure_threshold     = 6
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 6
          }
        }

        dynamic "container" {
          for_each = var.enable_twenty_worker ? [1] : []
          content {
            name    = "worker"
            image   = var.image
            command = ["yarn", "worker:prod"]

            resources {
              requests = {
                cpu    = "100m"
                memory = "256Mi"
              }
              limits = {
                cpu    = "400m"
                memory = "512Mi"
              }
            }

            env {
              name = "PG_DATABASE_URL"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.twenty_env.metadata[0].name
                  key  = "PG_DATABASE_URL"
                }
              }
            }
            env {
              name  = "SERVER_URL"
              value = local.server_url
            }
            env {
              name  = "REDIS_URL"
              value = local.redis_url
            }
            env {
              name = "APP_SECRET"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.twenty_env.metadata[0].name
                  key  = "APP_SECRET"
                }
              }
            }
            env {
              name  = "DISABLE_DB_MIGRATIONS"
              value = "true"
            }
            env {
              name  = "DISABLE_CRON_JOBS_REGISTRATION"
              value = "true"
            }
            env {
              name  = "LOCAL_STORAGE_PATH"
              value = "/app/packages/twenty-server/.local-storage"
            }
            env {
              name  = "NODE_OPTIONS"
              value = "--max-old-space-size=2048"
            }

            volume_mount {
              name       = "local-data"
              mount_path = "/app/packages/twenty-server/.local-storage"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "twenty" {
  metadata {
    name      = "twenty"
    namespace = kubernetes_namespace.twenty.metadata[0].name
    labels = {
      app = "twenty"
    }
  }

  spec {
    selector = {
      app = "twenty"
    }

    port {
      name        = "http"
      port        = 3000
      target_port = 3000
    }
  }
}

resource "kubernetes_deployment" "redis" {
  metadata {
    name      = "twenty-redis"
    namespace = kubernetes_namespace.twenty.metadata[0].name
    labels = {
      app = "twenty-redis"
    }
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "twenty-redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "twenty-redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:7-alpine"

          port {
            name           = "redis"
            container_port = 6379
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }

          liveness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 10
            period_seconds        = 15
            timeout_seconds       = 5
            failure_threshold     = 6
          }

          readiness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 6
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name      = "twenty-redis"
    namespace = kubernetes_namespace.twenty.metadata[0].name
    labels = {
      app = "twenty-redis"
    }
  }

  spec {
    selector = {
      app = "twenty-redis"
    }

    port {
      name        = "redis"
      port        = 6379
      target_port = 6379
    }
  }
}
