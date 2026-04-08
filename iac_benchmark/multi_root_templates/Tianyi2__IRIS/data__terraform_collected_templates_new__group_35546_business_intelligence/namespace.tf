resource "kubernetes_namespace_v1" "bi_namespace" {
  metadata {
    name = var.kubernetes_bi_namespace
  }
}