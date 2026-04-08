resource "kubernetes_namespace_v1" "notebooks_namespace" {
  metadata {
    name = local.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
