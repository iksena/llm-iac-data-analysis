resource "kubernetes_secret_v1" "tls_secret" {
  metadata {
    name      = "tls-secret"
    namespace = var.kubernetes_bi_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = var.tls_certificate
    "tls.key" = var.tls_private_key
  }
}

resource "kubernetes_ingress_v1" "ingress_bi_superset" {
  metadata {
    name      = "ingress-bi-superset"
    namespace = var.kubernetes_bi_namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"         = "true"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"    = "16k"
      "nginx.ingress.kubernetes.io/proxy-buffers-number" = "4"
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts       = ["superset.${var.kubernetes_ingress_base_host}"]
      secret_name = kubernetes_secret_v1.tls_secret.metadata[0].name
    }
    rule {
      host = "superset.${var.kubernetes_ingress_base_host}"
      http {
        path {
          backend {
            service {
              name = "superset"
              port {
                number = 8088
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.superset]
}
