terraform {
  required_version = ">= 1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    wireguard = {
      source  = "OJFord/wireguard"
      version = "0.3.1"
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
