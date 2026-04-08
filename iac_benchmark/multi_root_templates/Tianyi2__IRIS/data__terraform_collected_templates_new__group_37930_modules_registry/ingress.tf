locals {
  registry_annotations_https = merge(
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

  registry_annotations_http_redirect = {
    "kubernetes.io/ingress.class"                      = var.ingress_class_name
    "kubernetes.io/ingress.allow-http"                 = "true"
    "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
    "traefik.ingress.kubernetes.io/router.middlewares" = "infra-redirect-https@kubernetescrd"
  }
}

# HTTPS ingress (with redirect middleware) when TLS is enabled
resource "kubernetes_ingress_v1" "registry_https" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "registry"
    namespace   = kubernetes_namespace.registry.metadata[0].name
    annotations = local.registry_annotations_https
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
              name = kubernetes_service.registry.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}

# HTTP-only ingress that redirects to HTTPS
resource "kubernetes_ingress_v1" "registry_http_redirect" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "registry-http"
    namespace   = kubernetes_namespace.registry.metadata[0].name
    annotations = local.registry_annotations_http_redirect
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
              name = kubernetes_service.registry.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}

# Plain HTTP ingress when TLS is disabled (dev)
resource "kubernetes_ingress_v1" "registry_http_plain" {
  count = var.enable_tls ? 0 : 1

  metadata {
    name      = "registry"
    namespace = kubernetes_namespace.registry.metadata[0].name
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
              name = kubernetes_service.registry.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}
