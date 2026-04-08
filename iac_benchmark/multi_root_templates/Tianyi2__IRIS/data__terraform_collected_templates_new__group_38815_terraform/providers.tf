terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "3.8.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}
