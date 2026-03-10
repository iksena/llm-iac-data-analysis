# ── main.tf ────────────────────────────────────
resource "azurerm_resource_group" "backend" {
  name     = "${var.prefix}-be-rg"
  location = var.location
}

resource "azurerm_container_group" "backend" {
  name                = "${var.prefix}-be-cg"
  location            = azurerm_resource_group.backend.location
  resource_group_name = azurerm_resource_group.backend.name
  os_type             = "Linux"
  ip_address_type     = "Private"
  subnet_ids          = [var.subnet_id]


  container {
    name   = "backend-container"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  tags = var.common_tags
}

# ── variables.tf ────────────────────────────────────
variable "common_tags" {
  description = "Common tags to be applied to resources"
  type        = map(string)
}

variable "location" {
  description = "The location where resources will be created"
  type        = string
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to use for the frontend"
  type        = string
}

# ── outputs.tf ────────────────────────────────────
output "backend_public_dns" {
  value = azurerm_container_group.backend.fqdn

}

output "backend_ip_address" {
  value = azurerm_container_group.backend.ip_address

}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}