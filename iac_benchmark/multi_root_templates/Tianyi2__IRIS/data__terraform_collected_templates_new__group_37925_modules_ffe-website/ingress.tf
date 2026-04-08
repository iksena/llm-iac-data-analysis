locals {
  wordpress_www_host = "www.${var.host}"

  wordpress_annotations_https = merge(
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

  wordpress_annotations_http_redirect = {
    "kubernetes.io/ingress.class"                      = var.ingress_class_name
    "kubernetes.io/ingress.allow-http"                 = "true"
    "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
    "traefik.ingress.kubernetes.io/router.middlewares" = "infra-redirect-https@kubernetescrd"
  }
}

# Middleware to redirect www -> apex over HTTPS
resource "kubernetes_manifest" "wordpress_www_redirect" {
  count = var.enable_tls ? 1 : 0

  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "wordpress-www-redirect"
      namespace = kubernetes_namespace.wordpress.metadata[0].name
    }
    spec = {
      redirectRegex = {
        regex       = "https?://www\\.${var.host}/?(.*)"
        replacement = "https://${var.host}/$1"
        permanent   = true
      }
    }
  }
}

# HTTPS ingress (with TLS + redirect middleware) when TLS is enabled
resource "kubernetes_ingress_v1" "wordpress_https" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "wordpress"
    namespace   = kubernetes_namespace.wordpress.metadata[0].name
    annotations = local.wordpress_annotations_https
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
              name = kubernetes_service.wordpress.metadata[0].name
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

# HTTP-only ingress that just redirects to HTTPS when TLS is enabled
resource "kubernetes_ingress_v1" "wordpress_http_redirect" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name        = "wordpress-http"
    namespace   = kubernetes_namespace.wordpress.metadata[0].name
    annotations = local.wordpress_annotations_http_redirect
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
              name = kubernetes_service.wordpress.metadata[0].name
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

# HTTP-only ingress to catch www and redirect to apex
resource "kubernetes_ingress_v1" "wordpress_www_redirect" {
  count = var.enable_tls ? 1 : 0

  metadata {
    name      = "wordpress-www-http"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                      = var.ingress_class_name
      "kubernetes.io/ingress.allow-http"                 = "true"
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
      "traefik.ingress.kubernetes.io/router.middlewares" = "${kubernetes_namespace.wordpress.metadata[0].name}-wordpress-www-redirect@kubernetescrd"
    }
  }

  spec {
    ingress_class_name = var.ingress_class_name

    rule {
      host = local.wordpress_www_host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.wordpress.metadata[0].name
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

# Plain HTTP ingress when TLS is disabled (dev)
resource "kubernetes_ingress_v1" "wordpress_http_plain" {
  count = var.enable_tls ? 0 : 1

  metadata {
    name      = "wordpress"
    namespace = kubernetes_namespace.wordpress.metadata[0].name
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
              name = kubernetes_service.wordpress.metadata[0].name
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
