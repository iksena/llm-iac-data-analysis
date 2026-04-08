# Secret containing the Agartha realm configuration for Keycloak import
# Uses a Secret instead of ConfigMap because the realm JSON contains OAuth client secrets
resource "kubernetes_secret_v1" "keycloak_realm" {
  metadata {
    name      = "keycloak-realm-config"
    namespace = local.namespace
  }

  data = {
    "agartha-realm.json" = templatefile("${path.module}/templates/realm.json.tftpl", {
      grafana_client_secret      = var.grafana_oauth_client_secret
      superset_client_secret     = var.superset_oauth_client_secret
      trino_client_secret        = var.trino_oauth_client_secret
      minio_client_secret        = var.minio_oauth_client_secret
      jupyterhub_client_secret   = var.jupyterhub_oauth_client_secret
      dagster_client_secret      = var.dagster_oauth_client_secret
      prometheus_client_secret   = var.prometheus_oauth_client_secret
      alertmanager_client_secret = var.alertmanager_oauth_client_secret
      ingress_base_host          = var.kubernetes_ingress_base_host
    })
  }

  depends_on = [
    kubernetes_namespace_v1.identity_namespace
  ]
}
