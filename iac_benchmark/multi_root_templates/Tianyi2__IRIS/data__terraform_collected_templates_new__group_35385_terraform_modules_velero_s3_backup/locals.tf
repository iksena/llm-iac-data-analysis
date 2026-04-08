locals {
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart_reference = "velero"

  chart_install_name = var.chart_install_name != null ? var.chart_install_name : local.chart_reference

  namespace = var.namespace != null ? var.namespace : local.chart_install_name

  credentials_secret_name = "${local.chart_install_name}-credentials"

  backup_storage_location_name = "default"

  aws_plugin_repository = "velero/velero-plugin-for-aws"
}

locals {
  # Jinja Template Data Sources
  credentials_template_path = "${path.module}/templates/credentials.j2"
  jinja_context = jsonencode({
    bucket_access_id  = var.bucket_access_id
    bucket_access_key = var.bucket_access_key
  })
}
