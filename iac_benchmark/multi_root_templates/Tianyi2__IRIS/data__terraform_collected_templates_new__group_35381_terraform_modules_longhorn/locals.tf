locals {
  repository = "https://charts.longhorn.io"
  chart_reference = "longhorn"

  chart_install_name = var.chart_install_name != null ? var.chart_install_name : local.chart_reference

  namespace = var.namespace != null ? var.namespace : local.chart_install_name

  ingress_tls_secret_name = "${local.chart_install_name}-ingress-tls"

  ingress_path = "/"

  service_port = 80
}
