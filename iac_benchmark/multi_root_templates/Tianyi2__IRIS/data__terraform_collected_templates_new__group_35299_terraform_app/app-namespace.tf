resource "kubernetes_namespace" "tomcat" {
  metadata {
    name = "tomcat"
  }
}

