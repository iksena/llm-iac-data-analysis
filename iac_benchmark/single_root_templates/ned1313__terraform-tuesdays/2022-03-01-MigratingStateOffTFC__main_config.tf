# ── main.tf ────────────────────────────────────
##################################################################################
# LOCALS
##################################################################################


locals {
  resource_group_name   = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  app_service_plan_name = "${var.naming_prefix}-${random_integer.name_suffix.result}"
  app_service_name      = "${var.naming_prefix}-${random_integer.name_suffix.result}"
}

resource "random_integer" "name_suffix" {
  min = 10000
  max = 99999
}

##################################################################################
# APP SERVICE
##################################################################################

resource "azurerm_resource_group" "app_service" {
  name     = local.resource_group_name
  location = var.location

  tags = {
    "migrate" = "success"
  }
}

resource "azurerm_app_service_plan" "app_service" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.app_service.location
  resource_group_name = azurerm_resource_group.app_service.name
  #resource_group_name = azurerm_resource_group.app_service.bad_attribute

  sku {
    tier     = var.asp_tier
    size     = var.asp_size
    capacity = var.capacity
  }
}

resource "azurerm_app_service" "app_service" {
  name                = local.app_service_name
  location            = azurerm_resource_group.app_service.location
  resource_group_name = azurerm_resource_group.app_service.name
  app_service_plan_id = azurerm_app_service_plan.app_service.id
  https_only          = true

  source_control {
    repo_url           = "https://github.com/ned1313/nodejs-docs-hello-world"
    branch             = "main"
    manual_integration = true
    use_mercurial      = false
  }
}

# ── variables.tf ────────────────────────────────────
#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  description = "(Optional) Region where the Azure resources will be created. Defaults to East US."
  type        = string
  default     = "eastus"
}

variable "naming_prefix" {
  description = "(Optional) Naming prefix used for resources. Defaults to adolabs."
  type        = string
  default     = "tfc"
}

variable "asp_tier" {
  description = "(Required) Tier for App Service Plan (Standard, PremiumV2)."
  type        = string
  default     = "Standard"
}

variable "asp_size" {
  description = "(Required) Size for App Service Plan (S2, P1v2)."
  type        = string
  default     = "S1"
}

variable "capacity" {
  description = "(Optional) Number of instances for App Service Plan."
  type        = string
  default     = "1"
}

# ── terraform.tf ────────────────────────────────────
##################################################################################
# TERRAFORM CONFIG
##################################################################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
  #backend "azurerm" {
  #  key = "webapp"
  #}

  cloud {
    organization = "ned-in-the-cloud"
    workspaces {
      name = "tfc-migration-test"
    }
  }
}


##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  features {}
}