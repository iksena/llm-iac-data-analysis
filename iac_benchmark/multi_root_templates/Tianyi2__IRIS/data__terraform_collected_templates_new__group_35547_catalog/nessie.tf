# Secret for S3 credentials used by Nessie catalog
resource "kubernetes_secret_v1" "nessie_s3_credentials" {
  metadata {
    name      = "nessie-s3-credentials"
    namespace = var.kubernetes_catalog_namespace
  }

  data = {
    "aws-access-key" = var.storage_s3_access_key
    "aws-secret-key" = var.storage_s3_secret_key
  }

  depends_on = [
    kubernetes_namespace_v1.catalog_namespace
  ]
}

# Secret for PostgreSQL database password
resource "kubernetes_secret_v1" "nessie_postgres_password" {
  metadata {
    name      = "nessie-postgres-password"
    namespace = var.kubernetes_catalog_namespace
  }

  data = {
    "password"          = var.catalog_postgres_password
    "postgres-password" = var.catalog_postgres_password
  }

  depends_on = [
    kubernetes_namespace_v1.catalog_namespace
  ]
}

# Secret for JDBC datasource credentials (required by Nessie chart)
resource "kubernetes_secret_v1" "nessie_datasource_creds" {
  metadata {
    name      = "datasource-creds"
    namespace = var.kubernetes_catalog_namespace
  }

  data = {
    "username" = "postgres"
    "password" = var.catalog_postgres_password
  }

  depends_on = [
    kubernetes_namespace_v1.catalog_namespace
  ]
}

# PostgreSQL for Nessie
resource "helm_release" "nessie_postgres" {
  namespace  = var.kubernetes_catalog_namespace
  name       = "nessie-postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "18.2.3"

  set = [
    {
      name  = "auth.existingSecret"
      value = kubernetes_secret_v1.nessie_postgres_password.metadata[0].name
    },
    {
      name  = "auth.secretKeys.userPasswordKey"
      value = "password"
    },
    {
      name  = "auth.secretKeys.adminPasswordKey"
      value = "postgres-password"
    },
    {
      name  = "auth.database"
      value = "nessie"
    },
    {
      name  = "primary.persistence.enabled"
      value = "true"
    },
    {
      name  = "primary.persistence.size"
      value = "2Gi"
    },
    {
      name  = "volumePermissions.enabled"
      value = "true"
    },
    {
      name  = "primary.resources.requests.cpu"
      value = var.nessie_postgres_resources.requests.cpu
    },
    {
      name  = "primary.resources.requests.memory"
      value = var.nessie_postgres_resources.requests.memory
    },
    {
      name  = "primary.resources.limits.cpu"
      value = var.nessie_postgres_resources.limits.cpu
    },
    {
      name  = "primary.resources.limits.memory"
      value = var.nessie_postgres_resources.limits.memory
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.catalog_namespace,
    kubernetes_secret_v1.nessie_postgres_password
  ]
}

resource "helm_release" "nessie" {
  namespace  = var.kubernetes_catalog_namespace
  name       = "nessie"
  repository = "https://charts.projectnessie.org"
  chart      = "nessie"
  version    = "0.106.1"

  set = [
    {
      name  = "serviceAccount.name"
      value = "nessie-sa"
    },
    {
      name  = "versionStoreType"
      value = "JDBC"
    },
    {
      name  = "jdbc.jdbcUrl"
      value = "jdbc:postgresql://nessie-postgres-postgresql:5432/nessie"
    },
    # Iceberg REST catalog configuration
    {
      name  = "catalog.enabled"
      value = "true"
    },
    # S3 storage configuration
    {
      name  = "catalog.storage.s3.defaultOptions.endpoint"
      value = var.storage_s3_endpoint
    },
    {
      name  = "catalog.storage.s3.defaultOptions.pathStyleAccess"
      value = "true"
    },
    {
      name  = "catalog.storage.s3.defaultOptions.region"
      value = "us-east-1"
    },
    {
      name  = "catalog.storage.s3.defaultOptions.authType"
      value = "STATIC"
    },
    {
      name  = "catalog.storage.s3.defaultOptions.accessKeySecret.name"
      value = kubernetes_secret_v1.nessie_s3_credentials.metadata[0].name
    },
    {
      name  = "catalog.storage.s3.defaultOptions.accessKeySecret.awsAccessKeyId"
      value = "aws-access-key"
    },
    {
      name  = "catalog.storage.s3.defaultOptions.accessKeySecret.awsSecretAccessKey"
      value = "aws-secret-key"
    },
    # Use request signing instead of credential vending (simpler for MinIO)
    {
      name  = "catalog.storage.s3.defaultOptions.requestSigningEnabled"
      value = "true"
    },
    # Warehouse configuration
    {
      name  = "catalog.iceberg.defaultWarehouse"
      value = "warehouse"
    },
    {
      name  = "catalog.iceberg.warehouses[0].name"
      value = "warehouse"
    },
    {
      name  = "catalog.iceberg.warehouses[0].location"
      value = "s3://${var.storage_s3_warehouse_bucket}/"
    },
    {
      name  = "resources.requests.cpu"
      value = var.nessie_resources.requests.cpu
    },
    {
      name  = "resources.requests.memory"
      value = var.nessie_resources.requests.memory
    },
    {
      name  = "resources.limits.cpu"
      value = var.nessie_resources.limits.cpu
    },
    {
      name  = "resources.limits.memory"
      value = var.nessie_resources.limits.memory
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.catalog_namespace,
    kubernetes_secret_v1.nessie_s3_credentials,
    kubernetes_secret_v1.nessie_postgres_password
  ]
}