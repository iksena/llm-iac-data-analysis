# ── variables.tf ────────────────────────────────────
## Cloud Provider Information
variable "cloud_provider" {
  description = "Cloud provider to use for HVN - AWS is the default"
  type = string
  default = "aws"
}

variable "cloud_region" {
  description = "Region in the cloud provider where you want to create the HVN - AWS us-east-1 is default"
  type = string
  default = "us-east-1"
}

## HVN Information
variable "hvn_cidr_block" {
  description = "CIDR block for the HVN deployment"
  type = string
  default = "172.16.0.0/24"
}

variable "prefix" {
  description = "Naming prefix for HVN resource"
  type = string
  default = "taco"
}



# ── outputs.tf ────────────────────────────────────
output "hvn_id" {
  value = hcp_hvn.hvn.hvn_id
}

output "hvn_cidr_block" {
  value = var.hvn_cidr_block
}

# ── resources.tf ────────────────────────────────────
locals {
  name = "${lower(var.prefix)}-${random_id.seed.hex}"
}

resource "random_id" "seed" {
  byte_length = 4
}

resource "hcp_hvn" "hvn" {
  hvn_id         = local.name
  cloud_provider = var.cloud_provider
  region         = var.cloud_region
  cidr_block     = var.hvn_cidr_block
}



# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
      hcp = {
          source = "hashicorp/hcp"
          version = "~> 0.5"
      }
  }
}