resource "kubernetes_secret_v1" "velero_s3_credentials" {
  metadata {
    name      = local.velero_credentials_secret_name
    namespace = var.kubernetes_backup_namespace
  }

  data = {
    cloud = <<-EOT
      [default]
      aws_access_key_id=${var.s3_access_key}
      aws_secret_access_key=${var.s3_secret_key}
    EOT
  }

  depends_on = [
    kubernetes_namespace_v1.backup_namespace
  ]
}
