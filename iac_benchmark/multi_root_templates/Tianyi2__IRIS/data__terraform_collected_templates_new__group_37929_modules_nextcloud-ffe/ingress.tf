locals {
  nextcloud_annotations_https = {
    "kubernetes.io/ingress.class"                      = var.ingress_class_name
    "kubernetes.io/ingress.allow-http"                 = "true"
    "traefik.ingress.kubernetes.io/router.entrypoints" = "web,websecure"
    "traefik.ingress.kubernetes.io/router.middlewares" = "infra-redirect-https@kubernetescrd"
    "cert-manager.io/cluster-issuer"                   = "letsencrypt-prod"
    "traefik.ingress.kubernetes.io/router.tls"         = "true"
  }

  nextcloud_annotations_http_redirect = {
    "kubernetes.io/ingress.class"                      = var.ingress_class_name
    "kubernetes.io/ingress.allow-http"                 = "true"
    "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
    "traefik.ingress.kubernetes.io/router.middlewares" = "infra-redirect-https@kubernetescrd"
  }
}

# HTTPS ingress when TLS enabled
resource "kubernetes_ingress_v1" "nextcloud_https" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "nextcloud"
    namespace   = kubernetes_namespace.nextcloud.metadata[0].name
    annotations = local.nextcloud_annotations_https
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
              name = "nextcloud"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

# HTTP-only ingress that redirects to HTTPS when TLS enabled
resource "kubernetes_ingress_v1" "nextcloud_http_redirect" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "nextcloud-http"
    namespace   = kubernetes_namespace.nextcloud.metadata[0].name
    annotations = local.nextcloud_annotations_http_redirect
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
              name = "nextcloud"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

# Plain HTTP ingress when TLS disabled
resource "kubernetes_ingress_v1" "nextcloud_http_plain" {
  count = var.enable_tls ? 0 : 1

  metadata {
    name      = "nextcloud"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
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
              name = "nextcloud"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
