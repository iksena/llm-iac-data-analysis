locals {
  repository = "https://openebs.github.io/openebs"
  chart_reference = "openebs"

  chart_install_name = var.chart_install_name != null ? var.chart_install_name : local.chart_reference

  namespace = var.namespace != null ? var.namespace : local.chart_install_name
}
