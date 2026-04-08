resource "random_password" "superset_secret_key" {
  length           = 42
  special          = true
  override_special = "+/"
}

resource "random_password" "superset_admin_password" {
  length  = 32
  special = false
}

resource "kubernetes_secret_v1" "secret_superset_secret_key" {
  metadata {
    name      = "superset-secret-key"
    namespace = var.kubernetes_bi_namespace
  }

  data = {
    "SECRET_KEY" = random_password.superset_secret_key.result
  }

  depends_on = [
    kubernetes_namespace_v1.bi_namespace
  ]
}

resource "kubernetes_secret_v1" "superset_oauth_credentials" {
  metadata {
    name      = "superset-oauth-credentials"
    namespace = var.kubernetes_bi_namespace
  }

  data = {
    SUPERSET_SECRET_KEY     = random_password.superset_secret_key.result
    OAUTH_CLIENT_SECRET     = var.superset_oauth_client_secret
    SUPERSET_ADMIN_PASSWORD = random_password.superset_admin_password.result
  }

  depends_on = [
    kubernetes_namespace_v1.bi_namespace
  ]
}

resource "helm_release" "superset" {
  namespace  = var.kubernetes_bi_namespace
  name       = "superset"
  repository = "https://apache.github.io/superset"
  chart      = "superset"
  version    = "0.15.0"

  values = [
    templatefile("${path.module}/templates/superset_values.tftpl", {
      superset_node_replica_num     = var.superset_node_replica_num
      superset_worker_replica_num   = var.superset_worker_replica_num
      oauth_client_id               = var.superset_oauth_client_id
      keycloak_auth_url             = var.keycloak_auth_url
      keycloak_token_url            = var.keycloak_token_url
      keycloak_issuer_url           = var.keycloak_issuer_url
      keycloak_jwks_url             = var.keycloak_jwks_url
      keycloak_api_base_url         = var.keycloak_api_base_url
      oauth_credentials_secret_name = kubernetes_secret_v1.superset_oauth_credentials.metadata[0].name
      superset_admin_password       = random_password.superset_admin_password.result
      node_resources                = var.superset_node_resources
      worker_resources              = var.superset_worker_resources
      postgres_resources            = var.superset_postgres_resources
      redis_resources               = var.superset_redis_resources
      postgres_storage_size_gb      = var.superset_postgres_storage_size_gb
      redis_storage_size_gb         = var.superset_redis_storage_size_gb
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.bi_namespace,
    kubernetes_secret_v1.superset_oauth_credentials
  ]
}
