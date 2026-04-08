variable "kubernetes_identity_namespace" {
  type        = string
  description = "The Kubernetes namespace for identity services"
  default     = "agartha-identity"
}

variable "kubernetes_ingress_base_host" {
  type        = string
  description = "The base host for ingress access"
}

variable "keycloak_admin_password" {
  type        = string
  description = "The admin password for Keycloak"
  sensitive   = true
}

variable "keycloak_postgres_password" {
  type        = string
  description = "The password for Keycloak PostgreSQL database"
  sensitive   = true
}

variable "keycloak_postgres_storage_size_gb" {
  type        = number
  description = "The storage size for Keycloak PostgreSQL in GB"
  default     = 10
}

variable "keycloak_replicas" {
  type        = number
  description = "Number of Keycloak replicas"
  default     = 1
}

variable "grafana_oauth_client_secret" {
  type        = string
  description = "The client secret for Grafana OAuth integration with Keycloak"
  sensitive   = true
}

variable "superset_oauth_client_secret" {
  type        = string
  description = "The client secret for Superset OAuth integration with Keycloak"
  sensitive   = true
}

variable "trino_oauth_client_secret" {
  type        = string
  description = "The client secret for Trino OAuth integration with Keycloak"
  sensitive   = true
}

variable "minio_oauth_client_secret" {
  type        = string
  description = "The client secret for MinIO OAuth integration with Keycloak"
  sensitive   = true
}

variable "jupyterhub_oauth_client_secret" {
  type        = string
  description = "The client secret for JupyterHub OAuth integration with Keycloak"
  sensitive   = true
}

variable "dagster_oauth_client_secret" {
  type        = string
  description = "The client secret for Dagster OAuth integration with Keycloak"
  sensitive   = true
}

variable "prometheus_oauth_client_secret" {
  type        = string
  description = "The client secret for Prometheus OAuth integration with Keycloak"
  sensitive   = true
}

variable "alertmanager_oauth_client_secret" {
  type        = string
  description = "The client secret for Alertmanager OAuth integration with Keycloak"
  sensitive   = true
}

variable "tls_certificate" {
  type        = string
  description = "TLS certificate (PEM format)"
}

variable "tls_private_key" {
  type        = string
  description = "TLS private key (PEM format)"
  sensitive   = true
}

variable "allowed_ingress_namespaces" {
  type        = list(string)
  description = "List of namespaces allowed to ingress to identity namespace"
}

variable "keycloak_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for Keycloak"
  default = {
    requests = { cpu = "500m", memory = "1Gi" }
    limits   = { cpu = "1000m", memory = "2Gi" }
  }
}

variable "keycloak_postgres_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for Keycloak PostgreSQL"
  default = {
    requests = { cpu = "250m", memory = "256Mi" }
    limits   = { cpu = "500m", memory = "512Mi" }
  }
}
