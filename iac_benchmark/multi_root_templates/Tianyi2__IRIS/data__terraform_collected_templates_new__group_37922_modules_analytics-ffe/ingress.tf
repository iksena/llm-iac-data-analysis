locals {
  analytics_annotations_https = merge(
    {
      "kubernetes.io/ingress.class"                      = var.ingress_class_name
      "kubernetes.io/ingress.allow-http"                 = "true"
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web,websecure"
      "traefik.ingress.kubernetes.io/router.middlewares" = "infra-redirect-https@kubernetescrd"
    },
    var.enable_tls ? {
      "cert-manager.io/cluster-issuer"           = "letsencrypt-prod"
      "traefik.ingress.kubernetes.io/router.tls" = "true"
    } : {}
  )

  analytics_annotations_http_redirect = {
    "kubernetes.io/ingress.class"                      = var.ingress_class_name
    "kubernetes.io/ingress.allow-http"                 = "true"
    "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
    "traefik.ingress.kubernetes.io/router.middlewares" = "infra-redirect-https@kubernetescrd"
  }
}

# HTTPS ingress when TLS enabled
resource "kubernetes_ingress_v1" "analytics_https" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "analytics"
    namespace   = kubernetes_namespace.analytics.metadata[0].name
    annotations = local.analytics_annotations_https
  }

  spec {
    ingress_class_name = var.ingress_class_name

    tls {
      hosts       = [var.host]
      secret_name = var.tls_secret_name
    }

    rule {
      host = var.host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.vince.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# HTTP-only ingress that redirects to HTTPS when TLS enabled
resource "kubernetes_ingress_v1" "analytics_http_redirect" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "analytics-http"
    namespace   = kubernetes_namespace.analytics.metadata[0].name
    annotations = local.analytics_annotations_http_redirect
  }

  spec {
    ingress_class_name = var.ingress_class_name

    rule {
      host = var.host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.vince.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# Plain HTTP ingress when TLS disabled
resource "kubernetes_ingress_v1" "analytics_http_plain" {
  count = var.enable_tls ? 0 : 1

  metadata {
    name      = "analytics"
    namespace = kubernetes_namespace.analytics.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = var.ingress_class_name
    }
  }

  spec {
    ingress_class_name = var.ingress_class_name

    rule {
      host = var.host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.vince.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
