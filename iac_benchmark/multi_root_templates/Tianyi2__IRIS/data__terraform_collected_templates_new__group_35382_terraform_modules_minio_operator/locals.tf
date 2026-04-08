locals {
  repository = "https://operator.min.io"
  chart_reference = "operator"

  chart_install_name = var.chart_install_name != null ? var.chart_install_name : local.chart_reference # Because chart_reference is vague, the variable default is defined

  namespace = var.namespace != null ? var.namespace : local.chart_install_name
}
