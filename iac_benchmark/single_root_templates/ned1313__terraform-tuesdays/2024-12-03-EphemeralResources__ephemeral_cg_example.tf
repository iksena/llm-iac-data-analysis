# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}

}

ephemeral "azurerm_key_vault_secret" "example" {
  name         = var.key_vault_secret_name
  key_vault_id = var.key_vault_id
}

ephemeral "azurerm_key_vault_certificate" "example" {
  name         = var.key_vault_certificate_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_resource_group" "example" {
  name     = "ephemeral-resources"
  location = "East US"
}

resource "azurerm_container_group" "example" {
  name                = "ephemeral-continst"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_address_type     = "Public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    secure_environment_variables = {
      KEY_VAULT_SECRET = ephemeral.azurerm_key_vault_secret.example.value
    }

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  #provisioner "local-exec" {
  #  command = "echo ${ephemeral.azurerm_key_vault_secret.example.value}"
  #  
  #}

  tags = {
    environment = "testing"
  }
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
output "name" {
  value = var.key_vault_id

}

output "secret_name" {
  value = var.key_vault_secret_name
}

#output "secret_value" {
#  value = nonsensitive(ephemeral.azurerm_key_vault_secret.example.value)
#}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = ">= 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.11"
    }
  }
}