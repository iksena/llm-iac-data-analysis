module "velero" {
  count = var.velero_enabled ? 1 : 0
  depends_on = [
    module.velero_minio_tenant,
  ]
  source = "../velero_s3_backup"

  chart_cleanup_on_fail       = var.chart_cleanup_on_fail
  chart_dependency_update     = var.chart_dependency_update
  chart_linting_enabled       = var.chart_linting_enabled
  chart_recreate_pods         = var.chart_recreate_pods
  chart_replace               = var.chart_replace
  chart_upgrade_install       = var.chart_upgrade_install

  namespace                   = data.kubernetes_namespace.velero[0].metadata[0].name
  create_namespace            = false

  bucket_access_id            = module.velero_minio_tenant[0].tenant_access_id
  bucket_access_key           = module.velero_minio_tenant[0].tenant_access_key
  bucket_name                 = local.velero_bucket_name
  bucket_region               = local.velero_bucket_region
  bucket_endpoint             = local.velero_bucket_endpoint

  internal_kubectl_repository = var.velero_internal_kubectl_repository
  internal_kubectl_tag        = var.velero_internal_kubectl_tag

  scheduled_backups                   = var.velero_scheduled_backups
  scheduled_backup_common_labels      = var.velero_scheduled_backup_common_labels
  scheduled_backup_common_annotations = var.velero_scheduled_backup_common_annotations
}
