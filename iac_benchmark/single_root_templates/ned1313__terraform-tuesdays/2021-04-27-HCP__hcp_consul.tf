# ── variables.tf ────────────────────────────────────
variable "prefix" {
  description = "Naming prefix for Consul Cluster"
  type = string
  default = "taco"
}

variable "public_endpoint" {
  description = "Whether or not to create a public endpoint for Consul"
  type = bool
  default = false
}

variable "hvn_id" {
  description = "ID of the HVN to used with Consul"
  type = string
}

variable "tier" {
  description = "Tier of Consul to use, defaults to development"
  type = string
  default = "development"
}

# ── outputs.tf ────────────────────────────────────
output "consul_private_endpoint_url" {
  value = hcp_consul_cluster.consul.consul_private_endpoint_url 
}

output "consul_public_endpoint_url" {
  value = hcp_consul_cluster.consul.consul_public_endpoint_url 
}

output "consul_admin_token" {
  value = hcp_consul_cluster_root_token.consul.secret_id
  sensitive = true
}

output "consul_ca_file" {
  value = hcp_consul_cluster.consul.consul_ca_file
}

output "consul_config_file" {
  value = hcp_consul_cluster.consul.consul_config_file
}

# ── resources.tf ────────────────────────────────────
locals {
  name = "${lower(var.prefix)}-${random_id.seed.hex}"
}

resource "random_id" "seed" {
  byte_length = 4
}

resource "hcp_consul_cluster" "consul" {
  cluster_id = local.name
  hvn_id     = var.hvn_id
  tier       = var.tier
  public_endpoint = var.public_endpoint
}

resource "hcp_consul_cluster_root_token" "consul" {
  cluster_id = hcp_consul_cluster.consul.cluster_id
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