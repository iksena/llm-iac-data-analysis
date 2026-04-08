resource "kubernetes_namespace_v1" "identity_namespace" {
  metadata {
    name = var.kubernetes_identity_namespace
  }
}
