resource "kubernetes_secret_v1" "tls_secret" {
  metadata {
    name      = "tls-secret"
    namespace = var.kubernetes_catalog_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = var.tls_certificate
    "tls.key" = var.tls_private_key
  }
}

resource "kubernetes_ingress_v1" "ingress_catalog_nessie" {
  metadata {
    name      = "ingress-catalog-nessie"
    namespace = var.kubernetes_catalog_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts       = ["nessie.${var.kubernetes_ingress_base_host}"]
      secret_name = kubernetes_secret_v1.tls_secret.metadata[0].name
    }
    rule {
      host = "nessie.${var.kubernetes_ingress_base_host}"
      http {
        path {
          backend {
            service {
              name = "nessie"
              port {
                number = 19120
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.nessie]
}
