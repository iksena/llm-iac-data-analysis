resource "kubernetes_namespace" "n8n" {
  metadata {
    name = "n8n"
    labels = {
      app = "n8n"
    }
  }
}
