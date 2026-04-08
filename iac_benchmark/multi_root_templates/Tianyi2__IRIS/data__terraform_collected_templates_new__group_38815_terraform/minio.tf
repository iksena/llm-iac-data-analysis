variable "hetzner_storage_access_key" {
  description = "Hetzner Cloud Storage Access Key"
  type        = string
  sensitive   = true
}
variable "hetzner_storage_secret_key" {
  description = "Hetzner Cloud Storage Secret Key"
  type        = string
  sensitive   = true
}

provider "minio" {
  # nbg1: Nuremberg (DE)
  minio_server   = "nbg1.your-objectstorage.com"
  minio_user     = var.hetzner_storage_access_key
  minio_password = var.hetzner_storage_secret_key
  minio_region   = "nbg1"
  minio_ssl      = true
}

variable "s3_bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
}

resource "minio_s3_bucket" "bucket" {
  bucket         = var.s3_bucket_name
  acl            = "private"
  object_locking = false
}
