locals {
  use_s3                = var.storage_backend == "s3"
  s3_endpoint_effective = var.s3_endpoint != "" ? var.s3_endpoint : (var.s3_region != "" ? format("https://%s.digitaloceanspaces.com", var.s3_region) : "")
  storage_block = local.use_s3 ? {
    /*
        With remote storage (S3), disable dedupe unless a remote DB is configured.
        This avoids zot failing with "dedupe set to true with remote storage and database, but no remote database configured".
    */
    dedupe        = false
    rootDirectory = "/var/lib/registry"
    storageDriver = {
      name           = "s3"
      regionEndpoint = local.s3_endpoint_effective
      bucket         = var.s3_bucket
      region         = var.s3_region
      accessKey      = var.s3_access_key
      secretKey      = var.s3_secret_key
      secure         = var.s3_secure
    }
    } : {
    dedupe        = false
    rootDirectory = "/var/lib/registry"
    storageDriver = null
  }
  registry_auth_enabled = var.htpasswd_entry != ""
}

resource "kubernetes_deployment" "registry" {
  lifecycle {
    precondition {
      condition     = !(local.use_s3 && (var.s3_bucket == "" || local.s3_endpoint_effective == "" || var.s3_access_key == "" || var.s3_secret_key == ""))
      error_message = "S3 backend requires s3_endpoint/region (or endpoint override), s3_bucket, s3_access_key, s3_secret_key."
    }
  }

  metadata {
    name      = "registry"
    namespace = kubernetes_namespace.registry.metadata[0].name
    labels = {
      app = "registry"
    }
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = "registry"
      }
    }

    template {
      metadata {
        labels = {
          app = "registry"
        }
      }

      spec {
        container {
          name  = "zot"
          image = "ghcr.io/project-zot/zot-linux-amd64:latest"


          port {
            name           = "http"
            container_port = 5000
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/zot"
          }

          dynamic "volume_mount" {
            for_each = local.use_s3 ? [] : [1]
            content {
              name       = "data"
              mount_path = "/var/lib/registry"
            }
          }

          dynamic "volume_mount" {
            for_each = var.htpasswd_entry != "" ? [1] : []
            content {
              name       = "htpasswd"
              mount_path = "/etc/zot-auth"
              read_only  = true
            }
          }
        }

        volume {
          name = "config"

          secret {
            secret_name = kubernetes_secret.config.metadata[0].name
          }
        }

        dynamic "volume" {
          for_each = local.use_s3 ? [] : [1]
          content {
            name = "data"

            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim.data[0].metadata[0].name
            }
          }
        }

        dynamic "volume" {
          for_each = var.htpasswd_entry != "" ? [1] : []
          content {
            name = "htpasswd"

            secret {
              secret_name = kubernetes_secret.htpasswd[0].metadata[0].name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "registry" {
  metadata {
    name      = "registry"
    namespace = kubernetes_namespace.registry.metadata[0].name
    labels = {
      app = "registry"
    }
  }

  spec {
    port {
      name        = "http"
      port        = 5000
      target_port = 5000
    }

    selector = {
      app = "registry"
    }
  }
}
