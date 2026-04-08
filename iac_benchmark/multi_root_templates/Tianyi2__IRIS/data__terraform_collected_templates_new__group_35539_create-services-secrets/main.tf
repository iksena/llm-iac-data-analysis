locals {
  seaweedfs_password_secret = "${var.postgresql_secret_name}-seaweedfs"
  values_postgresql = {
    "POSTGRESQL_INITDB_SECRET" = var.postgresql_initdb_secret_name
    "MONITORING_NAMESPACE"     = var.monitoring_namespace
    "POSTGRESQL_SECRET_NAME"   = var.postgresql_secret_name
    "POSTGRESQL_PASSWORD"      = random_password.postgres_postgresql_password.result
  }
  initdb_data = {
    "COSMOTECH_API_READER_USERNAME" = var.cosmotech_api_reader_username
    "COSMOTECH_API_READER_PASSWORD" = random_password.postgresql_reader_password.result
    "COSMOTECH_API_WRITER_USERNAME" = var.cosmotech_api_writer_username
    "COSMOTECH_API_WRITER_PASSWORD" = random_password.postgresql_writer_password.result
    "COSMOTECH_API_ADMIN_USERNAME"  = var.cosmotech_api_admin_username
    "COSMOTECH_API_ADMIN_PASSWORD"  = random_password.postgresql_admin_password.result
    "ARGO_POSTGRESQL_USER"          = var.argo_postgresql_user
    "ARGO_POSTGRESQL_PASSWORD"      = random_password.argo_postgresql_password.result
    "ARGO_DATABSE"                  = var.argo_database
  }
  # s3_config_values = {
  #   "ARGO_WORKFLOWS_USERNAME" = var.argo_workflows_s3_username
  #   "ARGO_WORKFLOWS_PASSWORD" = random_password.seaweedfs_argo_workflows_password.result
  #   "COSMOTECH_API_USERNAME"  = var.cosmotech_api_s3_username
  #   "COSMOTECH_API_PASSWORD"  = random_password.seaweedfs_cosmotech_api_password.result
  # }
}

# postgres
resource "random_password" "postgres_postgresql_password" {
  length  = 30
  special = false
}

resource "random_password" "argo_postgresql_password" {
  length  = 30
  special = false
}

resource "random_password" "postgresql_reader_password" {
  length  = 30
  special = false
}

resource "random_password" "postgresql_writer_password" {
  length  = 30
  special = false
}

resource "random_password" "postgresql_admin_password" {
  length  = 30
  special = false
}

resource "kubernetes_secret" "postgresql_data" {
  metadata {
    name      = "postgresql-admin-data"
    namespace = var.kubernetes_namespace
  }
  data = {
    password = random_password.postgres_postgresql_password.result
    argo     = random_password.argo_postgresql_password.result
    reader   = random_password.postgresql_reader_password.result
    writer   = random_password.postgresql_writer_password.result
    admin    = random_password.postgresql_admin_password.result
  }
  timeouts {
    create = "5m"
  }
}

resource "kubernetes_secret" "postgresql-initdb" {
  metadata {
    name      = "postgres-initdb"
    namespace = var.kubernetes_namespace
    labels = {
      "app" = "postgres"
    }
  }
  data = {
    "initdb.sql" = templatefile("${path.module}/initdb.sql", local.initdb_data)
  }
  timeouts {
    create = "5m"
  }
}

resource "kubernetes_secret" "postgres-config" {
  metadata {
    name      = "postgres-config"
    namespace = var.kubernetes_namespace
    labels = {
      "app" = "postgres"
    }
  }

  data = {
    argo-username                 = var.argo_postgresql_user
    database-password             = random_password.argo_postgresql_password.result
    argo-password                 = random_password.argo_postgresql_password.result
    postgres-username             = "postgres"
    postgres-password             = random_password.postgres_postgresql_password.result
    cosmotech-api-admin-username  = var.cosmotech_api_admin_username
    cosmotech-api-admin-password  = random_password.postgresql_admin_password.result
    cosmotech-api-reader-username = var.cosmotech_api_reader_username
    cosmotech-api-reader-password = random_password.postgresql_reader_password.result
    cosmotech-api-writer-username = var.cosmotech_api_writer_username
    cosmotech-api-writer-password = random_password.postgresql_writer_password.result
  }

  type = "Opaque"
}

# redis
resource "random_password" "redis_admin_password" {
  count   = var.first_tenant_in_cluster ? 0 : 1
  length  = 30
  special = false
}

resource "kubernetes_secret" "redis_admin_password" {
  count = var.first_tenant_in_cluster ? 0 : 1
  metadata {
    name      = "redis-admin-secret"
    namespace = var.kubernetes_namespace
  }
  data = {
    password = random_password.redis_admin_password.0.result
  }
  type       = "Opaque"
  depends_on = [kubernetes_secret.redis_admin_password]
}


# # seaweedfs
# resource "random_password" "seaweedfs_argo_workflows_password" {
#   length  = 30
#   special = false
# }

# resource "random_password" "seaweedfs_cosmotech_api_password" {
#   length  = 30
#   special = false
# }

# resource "kubernetes_secret" "s3_credentials" {
#   metadata {
#     name      = "seaweedfs-${var.kubernetes_namespace}-s3-auth"
#     namespace = var.kubernetes_namespace
#     labels = {
#       "app" = "seaweedfs"
#     }
#   }
#   type = "Opaque"
#   data = {
#     "argo-workflows-username" = var.argo_workflows_s3_username
#     "argo-workflows-password" = random_password.seaweedfs_argo_workflows_password.result
#     "cosmotech-api-username"  = var.cosmotech_api_s3_username
#     "cosmotech-api-password"  = random_password.seaweedfs_cosmotech_api_password.result
#   }
# }

# resource "kubernetes_secret" "s3_auth_config" {
#   metadata {
#     name      = "seaweedfs-${var.kubernetes_namespace}-s3-config"
#     namespace = var.kubernetes_namespace
#     labels = {
#       "app" = "seaweedfs"
#     }
#   }

#   type = "Opaque"
#   data = {
#     "config.json" = templatefile("${path.module}/s3_config.json", local.s3_config_values)
#   }
# }

# resource "kubernetes_secret" "postgres-seaweedfs-config" {
#   metadata {
#     name      = local.seaweedfs_password_secret
#     namespace = var.kubernetes_namespace
#     labels = {
#       "app" = "postgres"
#     }
#   }

#   data = {
#     postgresql-username = var.seaweedfs_username
#     postgresql-password = random_password.seaweedfs_argo_workflows_password.result
#   }

#   type = "Opaque"
# }

# acr
resource "kubernetes_secret" "acr_login_password" {
  metadata {
    name      = "acr-admin-secret"
    namespace = var.kubernetes_namespace
  }

  data = {
    "password" = var.acr_admin_password
    "username" = var.acr_admin_username
    "registry" = var.acr_login_server
  }

  type = "Opaque"
}

# kusto
resource "kubernetes_secret" "kusto_account_password" {
  metadata {
    name      = "adx-admin-secret"
    namespace = var.kubernetes_namespace
  }

  data = {
    "name"         = var.kusto_name
    "uri"          = var.kusto_data_ingestion_uri
    "principal_id" = var.kusto_principal_id
  }

  type = "Opaque"
}

# storage
resource "kubernetes_secret" "storage_account_password" {
  metadata {
    name      = "storage-account-secret"
    namespace = var.kubernetes_namespace
  }

  data = {
    "name"     = var.storage_account_name
    "password" = var.storage_account_primary_access_key
  }

  type = "Opaque"
}
# platform
resource "kubernetes_secret" "platform_client_secret" {
  metadata {
    name      = "platform-client-secret"
    namespace = var.kubernetes_namespace
  }

  data = {
    "client_id" = var.platform_client_id
    "password"  = var.platform_password
  }

  type = "Opaque"
}
