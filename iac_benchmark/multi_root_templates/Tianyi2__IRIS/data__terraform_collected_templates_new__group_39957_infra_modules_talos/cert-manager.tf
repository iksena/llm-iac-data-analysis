locals {
  cert_manager = {
    repository = "https://charts.jetstack.io/"
    chart      = "cert-manager"
    version    = "1.16.3"
    namespace  = "cert-manager"

    issuer_name = "letsencrypt-${var.environment}"
  }
}

data "helm_template" "cert_manager" {
  name       = "cert-manager"
  repository = local.cert_manager.repository
  chart      = local.cert_manager.chart
  version    = local.cert_manager.version

  namespace    = local.cert_manager.namespace
  kube_version = var.k8s_version
}
