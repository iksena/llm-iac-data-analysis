resource "kubernetes_namespace_v1" "backup_namespace" {
  metadata {
    name = var.kubernetes_backup_namespace
  }
}
