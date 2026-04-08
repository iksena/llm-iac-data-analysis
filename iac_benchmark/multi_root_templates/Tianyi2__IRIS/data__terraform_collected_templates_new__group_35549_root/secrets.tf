# =============================================================================
# Auto-generated secrets
# =============================================================================
# All secrets are generated once and stored in Terraform state.
# To rotate a secret, use: terraform apply -replace=random_password.<name>

# S3 access key (alphanumeric, 20 chars)
resource "random_string" "s3_access_key" {
  length  = 20
  special = false
}

# S3 secret key (40 chars)
resource "random_password" "s3_secret_key" {
  length  = 40
  special = false
}

# Grafana admin password (24 chars)
resource "random_password" "grafana_admin" {
  length  = 24
  special = false
}

# Dagster PostgreSQL password (24 chars)
resource "random_password" "dagster_postgres" {
  length  = 24
  special = false
}

# Nessie (catalog) PostgreSQL password (24 chars)
resource "random_password" "catalog_postgres" {
  length  = 24
  special = false
}

# Keycloak admin password (24 chars)
resource "random_password" "keycloak_admin" {
  length  = 24
  special = false
}

# Keycloak PostgreSQL password (24 chars)
resource "random_password" "keycloak_postgres" {
  length  = 24
  special = false
}

# OAuth client secrets (32 chars each)
resource "random_password" "oauth_grafana" {
  length  = 32
  special = false
}

resource "random_password" "oauth_superset" {
  length  = 32
  special = false
}

resource "random_password" "oauth_trino" {
  length  = 32
  special = false
}

resource "random_password" "oauth_minio" {
  length  = 32
  special = false
}

resource "random_password" "oauth_jupyterhub" {
  length  = 32
  special = false
}

resource "random_password" "oauth_dagster" {
  length  = 32
  special = false
}

resource "random_password" "oauth_prometheus" {
  length  = 32
  special = false
}

resource "random_password" "oauth_alertmanager" {
  length  = 32
  special = false
}

# OAuth cookie secrets (16 bytes -> 32 hex chars)
resource "random_bytes" "cookie_dagster" {
  length = 16
}

resource "random_bytes" "cookie_prometheus" {
  length = 16
}

resource "random_bytes" "cookie_alertmanager" {
  length = 16
}

# Trino internal shared secret (32 bytes -> base64)
resource "random_bytes" "trino_internal_shared" {
  length = 32
}

# =============================================================================
# Locals mapping generated values to descriptive names
# =============================================================================

locals {
  storage_s3_access_key = random_string.s3_access_key.result
  storage_s3_secret_key = random_password.s3_secret_key.result

  monitoring_grafana_admin_password = random_password.grafana_admin.result

  orchestration_dagster_postgres_password = random_password.dagster_postgres.result
  catalog_postgres_password               = random_password.catalog_postgres.result

  identity_keycloak_admin_password    = random_password.keycloak_admin.result
  identity_keycloak_postgres_password = random_password.keycloak_postgres.result

  identity_grafana_oauth_client_secret      = random_password.oauth_grafana.result
  identity_superset_oauth_client_secret     = random_password.oauth_superset.result
  identity_trino_oauth_client_secret        = random_password.oauth_trino.result
  identity_minio_oauth_client_secret        = random_password.oauth_minio.result
  identity_jupyterhub_oauth_client_secret   = random_password.oauth_jupyterhub.result
  identity_dagster_oauth_client_secret      = random_password.oauth_dagster.result
  identity_prometheus_oauth_client_secret   = random_password.oauth_prometheus.result
  identity_alertmanager_oauth_client_secret = random_password.oauth_alertmanager.result

  orchestration_dagster_oauth_cookie_secret   = random_bytes.cookie_dagster.hex
  monitoring_prometheus_oauth_cookie_secret   = random_bytes.cookie_prometheus.hex
  monitoring_alertmanager_oauth_cookie_secret = random_bytes.cookie_alertmanager.hex

  processing_trino_internal_shared_secret = random_bytes.trino_internal_shared.base64
}
