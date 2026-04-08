variable "kubernetes_bi_namespace" {
  type        = string
  description = "The Kubernetes namespace to use for BI"
}

variable "kubernetes_ingress_base_host" {
  type        = string
  description = "The base host upon which to build the module Ingress subdomains"
}

variable "superset_node_replica_num" {
  type        = number
  description = "Number of Superset node replicas"
}

variable "superset_worker_replica_num" {
  type        = number
  description = "Number of Superset worker replicas"
}

# Keycloak OAuth integration variables
variable "superset_oauth_client_id" {
  type        = string
  description = "The OAuth client ID for Superset (from Keycloak)"
}

variable "superset_oauth_client_secret" {
  type        = string
  description = "The OAuth client secret for Superset (from Keycloak)"
  sensitive   = true
}

variable "keycloak_auth_url" {
  type        = string
  description = "The Keycloak OIDC authorization URL (external, for browser redirects)"
}

variable "keycloak_token_url" {
  type        = string
  description = "The Keycloak OIDC token URL (internal, for server-to-server)"
}

variable "keycloak_issuer_url" {
  type        = string
  description = "The Keycloak OIDC issuer URL (external, must match token iss claim)"
}

variable "keycloak_jwks_url" {
  type        = string
  description = "The Keycloak OIDC JWKS URL (internal, for server-to-server)"
}

variable "keycloak_api_base_url" {
  type        = string
  description = "The Keycloak OIDC API base URL (internal, for server-to-server)"
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
  description = "List of namespaces allowed to ingress to bi namespace"
}

variable "superset_node_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for Superset webserver nodes"
  default = {
    requests = { cpu = "250m", memory = "512Mi" }
    limits   = { cpu = "1000m", memory = "2Gi" }
  }
}

variable "superset_worker_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for Superset workers"
  default = {
    requests = { cpu = "250m", memory = "512Mi" }
    limits   = { cpu = "1000m", memory = "2Gi" }
  }
}

variable "superset_postgres_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for Superset PostgreSQL"
  default = {
    requests = { cpu = "250m", memory = "256Mi" }
    limits   = { cpu = "500m", memory = "512Mi" }
  }
}

variable "superset_redis_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for Superset Redis"
  default = {
    requests = { cpu = "50m", memory = "64Mi" }
    limits   = { cpu = "200m", memory = "256Mi" }
  }
}

variable "superset_postgres_storage_size_gb" {
  type        = number
  description = "Persistent storage size in GB for Superset PostgreSQL"
  default     = 8
}

variable "superset_redis_storage_size_gb" {
  type        = number
  description = "Persistent storage size in GB for Superset Redis"
  default     = 2
}