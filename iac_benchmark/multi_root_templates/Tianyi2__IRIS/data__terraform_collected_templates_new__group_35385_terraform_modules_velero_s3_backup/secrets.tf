resource "kubernetes_secret" "credentials" {
  depends_on = [
    data.kubernetes_namespace.namespace,
    data.jinja_template.credentials
  ]
  metadata {
    name = local.credentials_secret_name
    namespace = data.kubernetes_namespace.namespace.metadata[0].name
  }
  data = {
    cloud = replace(data.jinja_template.credentials.result, ",", "\\,")
  }
  type = "Opaque"
}
