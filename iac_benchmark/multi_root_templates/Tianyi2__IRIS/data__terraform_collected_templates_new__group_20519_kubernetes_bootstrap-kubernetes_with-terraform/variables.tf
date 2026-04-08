variable "main_domain" {
    description = "Main domain to be used in Helm values files"
    type        = string
    default     = "dena.mecan.ir"
}

variable "minio_server" {
    description = "Minio service api url"
    type        = string
    default     = "object.dena.mecan.ir:443"
}

variable "minio_root_username" {
    description = "Minio root access key"
    type        = string
    default     = "fiNscYkugIx4KMI0jLr41yIP"
}

variable "minio_root_password" {
    description = "Minio root secret key"
    type        = string
    default     = "M66IZ3u5ezjbwyocgDo3NPDxQ5cz7WIEV7Llt5G"
}

variable "grafana_password" {
    description = "The Grafana admin password"
    type        = string
    default     = "P25OhzpS5qL34cdtzMb4du40KgsGdhUJEOeDxIu"
}

variable "velero_bucket_name" {
    description = "The name of the bucket to create"
    type        = string
    default     = "velero-backups"
}

variable "velero_minio_username" {
    description = "The name of the user to create"
    type        = string
    default     = "velero-user"
}

variable "velero_minio_password" {
    description = "The password for the user"
    type        = string
    default     = "JpxUBnJnoLGDaUN3mnQ7jGLStk29MUg8LWro0QC"
}

variable "velero_policy_name" {
    description = "The name of the policy to create"
    type        = string
    default     = "velero-backup-policy"
}


