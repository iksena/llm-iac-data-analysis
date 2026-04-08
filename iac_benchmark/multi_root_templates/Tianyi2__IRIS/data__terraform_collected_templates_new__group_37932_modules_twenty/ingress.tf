locals {
  twenty_annotations = merge(
    {
      "kubernetes.io/ingress.class"                      = var.ingress_class_name
      "kubernetes.io/ingress.allow-http"                 = "true"
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web,websecure"
    },
    var.enable_tls ? {
      "cert-manager.io/cluster-issuer"                   = "letsencrypt-prod"
      "traefik.ingress.kubernetes.io/router.tls"         = "true"
      "traefik.ingress.kubernetes.io/router.middlewares" = "infra-redirect-https@kubernetescrd"
    } : {}
  )
}

resource "kubernetes_ingress_v1" "twenty" {
  metadata {
    name        = "twenty"
    namespace   = kubernetes_namespace.twenty.metadata[0].name
    annotations = local.twenty_annotations
  }

  spec {
    ingress_class_name = var.ingress_class_name

    dynamic "tls" {
      for_each = var.enable_tls ? [1] : []
      content {
        hosts       = [var.host]
        secret_name = var.tls_secret_name
      }
    }

    rule {
      host = var.host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.twenty.metadata[0].name
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }
}
