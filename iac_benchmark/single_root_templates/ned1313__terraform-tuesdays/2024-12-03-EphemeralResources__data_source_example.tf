# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}

}

#data "azurerm_key_vault_secret" "example" {
#  name         = var.key_vault_secret_name
#  key_vault_id = var.key_vault_id
#}
#
#data "azurerm_key_vault_certificate" "example" {
#  name         = var.key_vault_certificate_name
#  key_vault_id = var.key_vault_id
#}

ephemeral "azurerm_key_vault_secret" "example" {
  name         = var.key_vault_secret_name
  key_vault_id = var.key_vault_id
}

ephemeral "azurerm_key_vault_certificate" "example" {
  name         = var.key_vault_certificate_name
  key_vault_id = var.key_vault_id
}

output "change" {
  value = "This is a change"
}

# ── variables.tf ────────────────────────────────────
variable "key_vault_secret_name" {
  description = "The name of the secret in the Azure Key Vault."
  type        = string
}

variable "key_vault_certificate_name" {
  description = "The name of the certificate in the Azure Key Vault."
  type        = string

}

variable "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  type        = string

}

# ── outputs.tf ────────────────────────────────────
#output "name" {
#  value = data.azurerm_key_vault_secret.example.name
#}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.11"
    }
  }

  cloud {
    organization = "ned-in-the-cloud"
    workspaces {
      project = "terraform-tuesdays-demos"
      name    = "ephemeral-resources-data-source"
    }
  }
}