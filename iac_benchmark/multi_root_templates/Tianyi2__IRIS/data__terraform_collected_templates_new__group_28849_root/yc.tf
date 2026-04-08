terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  required_version = ">= 1.9.0"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    bucket = "kumaximbot-tf-state"
    key    = "ui-terraform.tfstate"
    region = "ru-central1-b"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
}

provider "yandex" {
  zone = "ru-central1-b"
}

locals {
  project_slug = "kumaximbot-ui"
}

variable "SERVICE_ACCOUNT_ID" {
  type      = string
  sensitive = true
  nullable  = false
}

output "domain" {
  value = yandex_storage_bucket.s3.website_endpoint
}

resource "yandex_iam_service_account_static_access_key" "sa-keys" {
  service_account_id = var.SERVICE_ACCOUNT_ID
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "s3" {
  access_key = yandex_iam_service_account_static_access_key.sa-keys.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-keys.secret_key
  bucket     = local.project_slug
  acl        = "public-read"

  website {
    index_document = "index.html"
  }

  cors_rule {
    allowed_methods = ["PUT", "POST", "GET", "DELETE"]
    allowed_headers = ["*"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
  }
}

module "template_files" {
  source   = "github.com/hashicorp/terraform-template-dir.git"
  base_dir = "${path.module}/dist"
}

resource "yandex_storage_object" "vuejs" {
  access_key = yandex_iam_service_account_static_access_key.sa-keys.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-keys.secret_key
  bucket     = yandex_storage_bucket.s3.bucket

  for_each = module.template_files.files

  key          = each.key
  source       = each.value.source_path
  source_hash  = each.value.digests.md5
  content_type = each.value.content_type
}


