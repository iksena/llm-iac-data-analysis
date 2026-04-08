variable "namespace" {
  type        = string
  default     = "registry"
  description = "Namespace K8S pour le registre privé"
}

variable "host" {
  type        = string
  description = "FQDN pour le registre (ex: registry.<root_domain>)"
}

variable "tls_secret_name" {
  type        = string
  default     = "registry-tls"
  description = "Secret TLS pour l’ingress du registre"
}

variable "ingress_class_name" {
  type        = string
  default     = "traefik"
  description = "IngressClassName (traefik prod, nginx dev)"
}

variable "enable_tls" {
  type        = bool
  default     = true
  description = "Activer TLS/cert-manager pour l'ingress du registre"
}

variable "storage_size" {
  type        = string
  default     = "20Gi"
  description = "Taille du PVC pour le registre"
}

variable "storage_backend" {
  type        = string
  default     = "local"
  description = "Backend de stockage: local (PVC) ou s3 (Spaces/MinIO)"
  validation {
    condition     = contains(["local", "s3"], var.storage_backend)
    error_message = "storage_backend must be 'local' or 's3'."
  }
}

variable "s3_endpoint" {
  type        = string
  default     = ""
  description = "Endpoint S3 (ex: https://nyc3.digitaloceanspaces.com ou http://minio.data.svc.cluster.local:9000)"
}

variable "s3_region" {
  type        = string
  default     = ""
  description = "Région S3 (ex: nyc3)"
}

variable "s3_bucket" {
  type        = string
  default     = ""
  description = "Bucket S3 pour le registre"
}

variable "s3_access_key" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Access key S3 (Spaces/MinIO)"
}

variable "s3_secret_key" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Secret key S3 (Spaces/MinIO)"
}

variable "s3_secure" {
  type        = bool
  default     = true
  description = "true si endpoint en HTTPS, false pour MinIO HTTP"
}

variable "htpasswd_entry" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Entrée htpasswd (user:bcrypt-hash) pour l’accès au registre"
}

variable "enable_velero" {
  type        = bool
  default     = true
  description = "Activer le Schedule Velero pour le namespace registry"
}

variable "velero_namespace" {
  type        = string
  default     = "velero"
  description = "Namespace Velero (pour le Schedule)"
}
