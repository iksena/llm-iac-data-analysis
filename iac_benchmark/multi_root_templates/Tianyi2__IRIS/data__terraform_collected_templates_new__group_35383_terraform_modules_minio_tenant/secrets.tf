resource "random_password" "access_key" {
  count            = local.generate_access_key ? 1 : 0
  length           = local.generated_access_key_length
  special          = false
  numeric          = true
  lower            = true
  upper            = true
  min_lower        = floor((local.generated_access_key_length / 2) / 3)
  min_upper        = ceil((local.generated_access_key_length / 2) / 3)
  min_numeric      = floor((local.generated_access_key_length / 2) / 3)
  keepers          = {
    generated_access_key_length = local.generated_access_key_length
  }
}

resource "kubernetes_secret" "password_secret" {
  depends_on = [
    random_password.access_key,
    data.kubernetes_namespace.namespace,
    data.jinja_template.configuration
  ]
  metadata {
    name = local.access_key_secret_name
    namespace = data.kubernetes_namespace.namespace.metadata[0].name
  }
  data = {
    "config.env" = replace(data.jinja_template.configuration.result, ",", "\\,")
  }
  type = "Opaque"
}
