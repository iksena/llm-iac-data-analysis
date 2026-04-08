locals {
  velero_minio_tenant_name = "velero-minio-tenant"
  velero_minio_tenant_pool = "velero-minio-pool"
  velero_minio_tenant_buckets = [
    {
      name = "velero"
      objectLock = false
      region = "minio"
    }
  ]

  velero_namespace = "velero"

  velero_bucket_name = length(module.velero_minio_tenant) > 0 ? module.velero_minio_tenant[0].tenant_bucket_names[0] : ""
  velero_bucket_region = length(module.velero_minio_tenant) > 0 ? module.velero_minio_tenant[0].tenant_bucket_regions_by_name[local.velero_bucket_name] : ""
  velero_bucket_endpoint = length(module.velero_minio_tenant) > 0 ? "${module.velero_minio_tenant[0].tenant_service_protocol}://${module.velero_minio_tenant[0].tenant_service_address}" : ""

  longhorn_namespace = "longhorn-system"
}
