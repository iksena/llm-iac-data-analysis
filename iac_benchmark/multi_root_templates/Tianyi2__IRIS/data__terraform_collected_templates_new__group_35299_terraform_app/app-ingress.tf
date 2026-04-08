resource "kubernetes_ingress" "app_ingress" {
  metadata {
    name = "app-ingress"

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "192.168.178.21"

      http {
        path {
          path = "/sample"

          backend {
            service_name = "service-tomcat"
            service_port = "8080"
          }
        }
      }
    }
  }
}

