resource "kubernetes_secret" "htpasswd" {
  count = var.htpasswd_entry != "" ? 1 : 0

  metadata {
    name      = "registry-htpasswd"
    namespace = kubernetes_namespace.registry.metadata[0].name
  }

  data = {
    htpasswd = var.htpasswd_entry
  }
}

resource "kubernetes_secret" "config" {
  metadata {
    name      = "registry-config"
    namespace = kubernetes_namespace.registry.metadata[0].name
  }

  data = {
    "config.json" = jsonencode({
      storage = local.storage_block
      http = {
        address = "0.0.0.0"
        port    = "5000"
        auth = local.registry_auth_enabled ? {
          htpasswd = {
            path = "/etc/zot-auth/htpasswd"
          }
        } : null
      }
      log = {
        level = "info"
      }
      extensions = {
        metrics = {
          enable = true
          prometheus = {
            path = "/metrics"
          }
        }
        /*
            Enable Zot GUI (+ search API backing it). The image already bundles zui.
        */
        ui = {
          enable = true
        }
        search = {
          enable = true
        }
      }
    })
  }
}
