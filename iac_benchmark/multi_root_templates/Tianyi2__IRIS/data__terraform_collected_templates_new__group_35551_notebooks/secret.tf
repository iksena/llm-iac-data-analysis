resource "kubernetes_secret_v1" "jupyterhub_oauth_secret" {
  metadata {
    name      = "jupyterhub-oauth-secret"
    namespace = local.namespace
    labels    = local.jupyterhub_labels
  }

  data = {
    client_id     = var.jupyterhub_oauth_client_id
    client_secret = var.jupyterhub_oauth_client_secret
  }

  depends_on = [
    kubernetes_namespace_v1.notebooks_namespace
  ]
}
