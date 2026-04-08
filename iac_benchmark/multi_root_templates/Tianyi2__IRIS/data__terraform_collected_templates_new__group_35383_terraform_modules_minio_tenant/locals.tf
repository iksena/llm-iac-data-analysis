locals {
  repository = "https://operator.min.io"
  chart_reference = "tenant"

  chart_install_name = var.chart_install_name != null ? var.chart_install_name : local.chart_reference # Because chart_reference is vague, the variable default is defined

  namespace = var.namespace != null ? var.namespace : local.chart_install_name

  generate_access_key = var.access_key == null ? true : false
  generated_access_key_length = 32

  access_key = var.access_key != null ? var.access_key : random_password.access_key[0].result

  access_key_secret_name = "${local.chart_install_name}-access-key"
}


locals {
  # Jinja Template Data Sources
  configuration_template_path = "${path.module}/templates/configuration.j2"
  jinja_context = jsonencode({
    access_id  = var.access_id
    access_key = local.access_key
  })
}
