# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}
  client_id       = data.vault_azure_access_credentials.creds.client_id
  client_secret   = data.vault_azure_access_credentials.creds.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

provider "vault" {
    namespace = var.vault_namespace
  auth_login {
    path = "auth/${var.approle_path}/login"
    namespace = var.vault_namespace
    parameters = {
      role_id   = var.role_id
      secret_id = var.secret_id
    }
  }
}

data "vault_azure_access_credentials" "creds" {
  backend                     = var.vault_azure_secret_backend_path
  role                        = var.vault_azure_secret_backend_role_name
  validate_creds              = true
  num_sequential_successes    = 3
  num_seconds_between_tests   = 1
  max_cred_validation_seconds = 100
}

# Create a single resource group
resource "azurerm_resource_group" "test" {
  name     = "approle-test"
  location = "eastus"
}

# ── variables.tf ────────────────────────────────────
variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID"
}

variable "approle_path" {
  type        = string
  description = "The AppRole path without the trailing slash"
}

variable "role_id" {
  type        = string
  description = "The AppRole role ID"
}

variable "secret_id" {
  type        = string
  description = "The AppRole secret ID"
  sensitive   = true
}

variable "vault_azure_secret_backend_path" {
  type        = string
  description = "The Azure Secrets path in vault without the trailing slash"
}

variable "vault_azure_secret_backend_role_name" {
  type        = string
  description = "The Azure Secrets role name in Vault"
}

variable "vault_namespace" {
  type = string
  description = "The Vault namespace"
  default = null
}
  

# ── versions.tf ────────────────────────────────────
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>3.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}