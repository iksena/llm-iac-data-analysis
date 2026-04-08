resource "helm_release" "velero" {
  namespace        = var.kubernetes_backup_namespace
  name             = "velero"
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  chart            = "velero"
  version          = "8.7.1"
  create_namespace = false

  values = [
    templatefile("${path.module}/templates/velero_values.tftpl", {
      s3_endpoint           = var.s3_endpoint
      s3_backup_bucket      = var.s3_backup_bucket_name
      credentials_secret    = local.velero_credentials_secret_name
      backup_schedule_name  = local.backup_schedule_name
      backup_schedule       = var.backup_schedule
      backup_retention_days = var.backup_retention_days
      backup_namespaces     = var.backup_namespaces
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.backup_namespace,
    kubernetes_secret_v1.velero_s3_credentials
  ]
}
