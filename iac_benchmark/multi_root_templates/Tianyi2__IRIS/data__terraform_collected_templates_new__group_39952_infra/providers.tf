terraform {
  backend "s3" {
  }
  required_version = ">= 1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = true

  ssh {
    agent = true
  }
}
