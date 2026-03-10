# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

}

# Add networking module
module "network" {
  source = "../../modules/network"

  location    = var.location
  prefix      = var.prefix
  common_tags = var.common_tags
  cidr_block  = var.cidr_block
  subnets     = var.subnets
}

# Add frontend module
module "frontend" {
  source = "../../modules/frontend"

  location    = var.location
  prefix      = var.prefix
  common_tags = var.common_tags
}

module "backend" {
  source = "../../modules/backend"

  location    = var.location
  prefix      = var.prefix
  common_tags = var.common_tags
  subnet_id   = module.network.subnet_id_map["backend"]
}

module "db" {
  source = "../../modules/db"

  location    = var.location
  prefix      = var.prefix
  common_tags = var.common_tags
  subnet_id   = module.network.subnet_id_map["db"]
}

# ── variables.tf ────────────────────────────────────
variable "location" {
  description = "The location to use for the network"
  type        = string

}

variable "prefix" {
  description = "The prefix to use for the network"
  type        = string

}

variable "common_tags" {
  description = "The common tags to use for the network"
  type        = map(string)

}

variable "cidr_block" {
  description = "The CIDR block to use for the network"
  type        = string

}

variable "subnets" {
  type = map(object({
    address_prefixes           = string
    delegation_name            = optional(string)
    service_delegation_name    = optional(string)
    service_delegation_actions = optional(list(string))
    service_endpoints          = optional(list(string))
  }))
  description = "Map of subnets to create"
}

variable "subscription_id" {
  description = "The subscription ID to use for the network"
  type        = string

}

# ── outputs.tf ────────────────────────────────────
output "fe_fqdn" {
  value = "https://${module.frontend.frontend_public_dns}"

}

output "be_ip_address" {
  value = module.backend.backend_ip_address
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    key = "prod/terraform.tfstate"
  }
}