locals {
  longhorn = {
    repository = "https://charts.longhorn.io/"
    chart      = "longhorn"
    version    = "1.8.0"
    namespace  = "longhorn-system"
  }
}

data "helm_template" "longhorn" {
  name       = "longhorn"
  repository = local.longhorn.repository
  chart      = local.longhorn.chart
  version    = local.longhorn.version

  namespace    = local.longhorn.namespace
  kube_version = var.k8s_version

  values = [file("${path.module}/templates/longhorn.yaml")]
}
