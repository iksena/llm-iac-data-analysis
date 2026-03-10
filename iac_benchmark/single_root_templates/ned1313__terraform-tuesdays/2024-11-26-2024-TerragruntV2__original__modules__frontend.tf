# ── main.tf ────────────────────────────────────
resource "azurerm_resource_group" "frontend" {
  name     = "${var.prefix}-fe-rg"
  location = var.location
}

resource "azurerm_container_group" "frontend" {
  name                = "${var.prefix}-fe-cg"
  location            = azurerm_resource_group.frontend.location
  resource_group_name = azurerm_resource_group.frontend.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "${var.prefix}-frontend-dns"


  container {
    name   = "frontend-container"
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

# ── outputs.tf ────────────────────────────────────
output "frontend_public_dns" {
  value = azurerm_container_group.frontend.fqdn

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