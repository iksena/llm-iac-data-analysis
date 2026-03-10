# ── variables.tf ────────────────────────────────────
variable "prefix" {
  description = "Naming prefix for Vault Cluster"
  type = string
  default = "taco"
}

variable "public_endpoint" {
  description = "Whether or not to create a public endpoint for Vault"
  type = bool
  default = false
}

variable "hvn_id" {
  description = "ID of the HVN to used with Vault"
  type = string
}

# ── outputs.tf ────────────────────────────────────
output "vault_private_endpoint_url" {
  value = hcp_vault_cluster.vault.vault_private_endpoint_url
}

output "vault_public_endpoint_url" {
  value = hcp_vault_cluster.vault.vault_public_endpoint_url
}

output "vault_admin_token" {
  value = hcp_vault_cluster_admin_token.vault.token
  sensitive = true
}

# ── resources.tf ────────────────────────────────────
locals {
  name = "${lower(var.prefix)}-${random_id.seed.hex}"
}

resource "random_id" "seed" {
  byte_length = 4
}

resource "hcp_vault_cluster" "vault" {
  cluster_id = local.name
  hvn_id     = var.hvn_id
  public_endpoint = var.public_endpoint
}

resource "hcp_vault_cluster_admin_token" "vault" {
  cluster_id = hcp_vault_cluster.vault.cluster_id
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