resource "kubernetes_secret_v1" "tls_secret" {
  metadata {
    name      = "tls-secret"
    namespace = local.namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = var.tls_certificate
    "tls.key" = var.tls_private_key
  }
}

resource "kubernetes_ingress_v1" "jupyterhub" {
  metadata {
    name      = "jupyterhub-ingress"
    namespace = local.namespace
    labels    = local.jupyterhub_labels

    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"         = "true"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"    = "16k"
      "nginx.ingress.kubernetes.io/proxy-buffers-number" = "4"
      "nginx.ingress.kubernetes.io/proxy-body-size"      = "100m"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"   = "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout"   = "3600"
      "nginx.ingress.kubernetes.io/proxy-http-version"   = "1.1"
      "nginx.ingress.kubernetes.io/upstream-hash-by"     = "$request_uri"
      "nginx.ingress.kubernetes.io/websocket-services"   = "proxy-public"
      "nginx.ingress.kubernetes.io/affinity"             = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name"  = "jupyterhub-session"
      "nginx.ingress.kubernetes.io/session-cookie-path"  = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = [local.jupyterhub_host]
      secret_name = kubernetes_secret_v1.tls_secret.metadata[0].name
    }

    rule {
      host = local.jupyterhub_host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "proxy-public"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.jupyterhub]
}
