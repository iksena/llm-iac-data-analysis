variable "kubernetes_backup_namespace" {
  type        = string
  description = "The namespace for Velero backup services"
}

variable "s3_endpoint" {
  type        = string
  description = "The MinIO internal endpoint URL"
}

variable "s3_access_key" {
  type        = string
  description = "The S3 access key for MinIO"
}

variable "s3_secret_key" {
  type        = string
  description = "The S3 secret key for MinIO"
  sensitive   = true
}

variable "s3_backup_bucket_name" {
  type        = string
  description = "The S3 bucket name for storing backups"
  default     = "agartha-backups"
}

variable "backup_schedule" {
  type        = string
  description = "Cron schedule for automated backups"
  default     = "0 2 * * *"
}

variable "backup_retention_days" {
  type        = number
  description = "Number of days to retain backups"
  default     = 7
}

variable "backup_namespaces" {
  type        = list(string)
  description = "List of namespaces to back up"
}

variable "allowed_ingress_namespaces" {
  type        = list(string)
  description = "List of namespaces allowed to send ingress traffic"
}
