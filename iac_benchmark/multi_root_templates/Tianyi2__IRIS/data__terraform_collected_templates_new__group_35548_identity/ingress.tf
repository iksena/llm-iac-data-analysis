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

resource "kubernetes_ingress_v1" "keycloak_ingress" {
  metadata {
    name      = "keycloak-ingress"
    namespace = local.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"         = "true"
      "nginx.ingress.kubernetes.io/proxy-body-size"      = "10m"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"    = "128k"
      "nginx.ingress.kubernetes.io/proxy-buffers-number" = "4"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = [local.keycloak_host]
      secret_name = kubernetes_secret_v1.tls_secret.metadata[0].name
    }

    rule {
      host = local.keycloak_host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "keycloak"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace_v1.identity_namespace,
    helm_release.keycloak
  ]
}
