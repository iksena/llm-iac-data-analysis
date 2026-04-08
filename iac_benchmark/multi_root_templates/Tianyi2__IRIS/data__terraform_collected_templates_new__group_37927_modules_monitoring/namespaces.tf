/*
    Namespace for monitoring stack
*/
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
