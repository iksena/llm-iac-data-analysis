resource "helm_release" "application" {
  depends_on = [
    data.kubernetes_namespace.namespace,
    kubernetes_secret.credentials
  ]

  name       = local.chart_install_name
  repository = local.repository
  chart      = local.chart_reference
  version    = var.chart_version

  namespace        = data.kubernetes_namespace.namespace.metadata[0].name
  create_namespace = false

  dependency_update = var.chart_dependency_update
  lint              = var.chart_linting_enabled
  recreate_pods     = var.chart_recreate_pods
  upgrade_install   = var.chart_upgrade_install
  replace           = var.chart_replace
  cleanup_on_fail   = var.chart_cleanup_on_fail

  set = [
    {
      name  = "dnsPolicy"
      value = var.dns_policy
    },
    {
      name  = "kubectl.image.repository"
      value = var.internal_kubectl_repository
    },
    {
      name  = "kubectl.image.tag"
      value = var.internal_kubectl_tag
    },
    {
      name  = "credentials.useSecret"
      value = "true"
    },
    {
      name  = "credentials.existingSecret"
      value = kubernetes_secret.credentials.metadata[0].name
    },
    {
      name  = "initContainers[0].name"
      value = "velero-plugin-for-aws"
    },
    {
      name  = "initContainers[0].image"
      value = "${local.aws_plugin_repository}:${var.aws_plugin_tag}"
    },
    {
      name  = "initContainers[0].volumeMounts[0].mountPath"
      value = "/target"
    },
    {
      name  = "initContainers[0].volumeMounts[0].name"
      value = "plugins"
    },
    {
      name  = "backupsEnabled"
      value = "true"
    },
    {
      name  = "snapshotsEnabled"
      value = "false"
    },
    {
      name  = "configuration.backupStorageLocation[0].name"
      value = local.backup_storage_location_name
    },
    {
      name  = "configuration.backupStorageLocation[0].default"
      value = "true"
    },
    {
      name  = "configuration.backupStorageLocation[0].provider"
      value = "aws"
    },
    {
      name  = "configuration.backupStorageLocation[0].bucket"
      value = var.bucket_name
    },
    {
      name  = "configuration.backupStorageLocation[0].config.region"
      value = var.bucket_region
    },
    {
      name  = "configuration.backupStorageLocation[0].config.s3ForcePathStyle"
      value = "true"
    },
    {
      name  = "configuration.backupStorageLocation[0].config.s3Url"
      value = var.bucket_endpoint
    }
  ]
}
