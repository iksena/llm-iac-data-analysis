resource "kubernetes_namespace_v1" "catalog_namespace" {
  metadata {
    name = var.kubernetes_catalog_namespace
  }
}