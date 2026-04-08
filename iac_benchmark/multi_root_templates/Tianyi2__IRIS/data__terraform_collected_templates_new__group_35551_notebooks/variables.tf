variable "kubernetes_notebooks_namespace" {
  type        = string
  description = "The Kubernetes namespace for the notebooks service"
}

variable "kubernetes_ingress_base_host" {
  type        = string
  description = "The base host upon which to build the module Ingress subdomains"
}

variable "nessie_uri" {
  type        = string
  description = "The Nessie Iceberg REST catalog URI"
}

variable "trino_host" {
  type        = string
  description = "The Trino coordinator host"
}

variable "trino_port" {
  type        = number
  description = "The Trino coordinator port"
  default     = 8080
}

variable "jupyterhub_storage_size_gb" {
  type        = number
  description = "Size of the persistent storage for each JupyterHub user"
  default     = 10
}

variable "jupyterhub_oauth_client_id" {
  type        = string
  description = "The OAuth client ID for JupyterHub"
}

variable "jupyterhub_oauth_client_secret" {
  type        = string
  description = "The OAuth client secret for JupyterHub"
  sensitive   = true
}

variable "keycloak_auth_url" {
  type        = string
  description = "The Keycloak authorization URL"
}

variable "keycloak_token_url" {
  type        = string
  description = "The Keycloak token URL"
}

variable "keycloak_userinfo_url" {
  type        = string
  description = "The Keycloak userinfo URL"
}

variable "jupyterhub_singleuser_image" {
  type        = string
  description = "The Docker image to use for JupyterHub single-user servers"
  default     = "quay.io/jupyter/scipy-notebook:notebook-7.5.1"
}

variable "jupyterhub_singleuser_cpu_limit" {
  type        = string
  description = "CPU limit for single-user servers"
  default     = "2000m"
}

variable "jupyterhub_singleuser_memory_limit" {
  type        = string
  description = "Memory limit for single-user servers"
  default     = "4Gi"
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
  description = "List of namespaces allowed to ingress to notebooks namespace"
}

variable "jupyterhub_hub_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for JupyterHub hub"
  default = {
    requests = { cpu = "250m", memory = "512Mi" }
    limits   = { cpu = "500m", memory = "1Gi" }
  }
}

variable "jupyterhub_proxy_resources" {
  type = object({
    requests = object({ cpu = string, memory = string })
    limits   = object({ cpu = string, memory = string })
  })
  description = "Resource requests and limits for JupyterHub proxy"
  default = {
    requests = { cpu = "100m", memory = "256Mi" }
    limits   = { cpu = "500m", memory = "512Mi" }
  }
}
