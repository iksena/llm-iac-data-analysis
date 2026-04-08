variable "cosmotech_api_reader_username" {
  type = string
}

variable "cosmotech_api_writer_username" {
  type = string
}

variable "cosmotech_api_admin_username" {
  type = string
}

variable "postgresql_initdb_secret_name" {
  type = string
}

variable "argo_postgresql_user" {
  type = string
}

variable "postgresql_secret_name" {
  type = string
}

variable "argo_database" {
  type = string
}

variable "kubernetes_namespace" {
  type = string
}

variable "monitoring_namespace" {
  type = string
}

# variable "rabbitmq_listener_username" {
#   type = string
# }

# variable "rabbitmq_sender_username" {
#   type = string
# }

variable "first_tenant_in_cluster" {
  type = bool
}

variable "argo_workflows_s3_username" {
  type = string
}
variable "cosmotech_api_s3_username" {
  type = string
}

# variable "seaweedfs_username" {
#   type = string
# }

# variable "seaweedfs_database" {
#   type = string
# }

variable "acr_admin_password" {
  type = string
}
variable "acr_admin_username" {
  type = string
}
variable "acr_login_server" {
  type = string
}

variable "kusto_name" {
  type = string
}
variable "kusto_data_ingestion_uri" {
  type = string
}
variable "kusto_principal_id" {
  type = string
}

variable "storage_account_name" {
  type = string
}
variable "storage_account_primary_access_key" {
  type = string
}

# variable "keycloak_app_client_id" {
#   type = string
# }
# variable "keycloak_app_password" {
#   type = string
# }

variable "platform_client_id" {
  type = string
}
variable "platform_password" {
  type = string
}
