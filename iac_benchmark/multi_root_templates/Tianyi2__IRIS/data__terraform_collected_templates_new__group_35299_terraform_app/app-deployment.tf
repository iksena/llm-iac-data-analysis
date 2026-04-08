resource "kubernetes_deployment" "tomcat" {
  metadata {
    name      = "tomcat"
    namespace = "tomcat"
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        app = "tomcat"
      }
    }

    template {
      metadata {
        labels = {
          app = "tomcat"
        }
      }

      spec {
        container {
          name  = "tomcat"
          image = "tomcat:8.0"

          liveness_probe {
            http_get {
              path   = "/sample"
              port   = "8080"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path   = "/sample"
              port   = "8080"
              scheme = "HTTP"
            }
          }

          image_pull_policy = "Always"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "1"
      }
    }
  }
}

