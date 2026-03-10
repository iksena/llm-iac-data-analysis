# ── main.tf ────────────────────────────────────
## Azure provider
provider "azurerm" {
  features {}
}

## First we need a resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-castai"
  location = var.location
}

## And a virtual network
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "4.1.0"
  resource_group_name = azurerm_resource_group.main.name
  use_for_each        = true
  vnet_location       = azurerm_resource_group.main.location
  vnet_name           = "${var.prefix}-castai"
  address_space       = ["10.42.0.0/16"]
  subnet_names        = ["aks"]
  subnet_prefixes     = ["10.42.0.0/24"]
}

## We'll start by deploying an AKS cluster
module "aks" {
  source                            = "Azure/aks/azurerm"
  version                           = "7.5.0"
  resource_group_name               = azurerm_resource_group.main.name
  prefix                            = var.prefix
  role_based_access_control_enabled = true
  rbac_aad                          = false
  vnet_subnet_id                    = lookup(module.vnet.vnet_subnets_name_id, "aks")

  depends_on = [azurerm_resource_group.main]
}

# ── variables.tf ────────────────────────────────────
variable "prefix" {
  type        = string
  description = "Short prefix to use for naming. Should be six characters or less. Defaults to test."
  default     = "test"

  validation {
    condition     = length(var.prefix) <= 6
    error_message = "The length of the prefix must be six or less characters."
  }
}

variable "location" {
  type        = string
  description = "Region to use for deployment. Defaults to eastus."
  default     = "eastus"
}

variable "castai_api_url" {
  type        = string
  description = "URL of alternative CAST AI API to be used during development or testing"
  default     = "https://api.cast.ai"
}

# Variables required for connecting AKS cluster to CAST AI
variable "castai_api_token" {
  type        = string
  description = "CAST AI API token created in console.cast.ai API Access keys section"
}

variable "castai_grpc_url" {
  type        = string
  description = "CAST AI gRPC URL"
  default     = "grpc.cast.ai:443"
}

# ── outputs.tf ────────────────────────────────────
output "client_certificate" {
  value = module.aks.client_certificate
  sensitive = true
}

output "client_key" {
  value = module.aks.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value = module.aks.cluster_ca_certificate
  sensitive = true
}

output "host" {
  value = module.aks.host
  sensitive = true
}

# ── castai.tf ────────────────────────────────────
# 3. Connect AKS cluster to CAST AI in READ-ONLY mode.

# Configure Data sources and providers required for CAST AI connection.
data "azurerm_subscription" "current" {}

provider "castai" {
  api_token = var.castai_api_token
  api_url   = var.castai_api_url
}

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

# Configure AKS cluster connection to CAST AI using CAST AI aks-cluster module.
module "castai-aks-cluster" {
  source = "castai/aks/castai"

  api_url                = var.castai_api_url
  castai_api_token       = var.castai_api_token
  grpc_url               = var.castai_grpc_url
  wait_for_cluster_ready = false

  aks_cluster_name    = module.aks.aks_name
  aks_cluster_region  = azurerm_resource_group.main.location
  node_resource_group = module.aks.node_resource_group
  resource_group      = azurerm_resource_group.main.name

  delete_nodes_on_disconnect = false

  subscription_id = data.azurerm_subscription.current.subscription_id
  tenant_id       = data.azurerm_subscription.current.tenant_id

  default_node_configuration = module.castai-aks-cluster.castai_node_configurations["default"]

  node_configurations = {
    default = {
      disk_cpu_ratio = 25
      subnets        = [lookup(module.vnet.vnet_subnets_name_id, "aks")]
      tags           = {}
    }
  }
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = "~>1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~>2.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.25"
    }

    castai = {
      source  = "castai/castai"
      version = "~>6.2"
    }
  }
}