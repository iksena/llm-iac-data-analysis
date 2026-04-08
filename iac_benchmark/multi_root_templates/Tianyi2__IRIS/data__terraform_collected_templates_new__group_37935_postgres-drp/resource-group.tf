# Azure resource group
resource "azurerm_resource_group" "rg_primary" {
  name = "${var.project_prefix}-rg-${var.environment}"
  location = var.primary_location
  tags = var.tags
}

resource "azurerm_resource_group" "rg_secondary" {
  name = "${var.project_prefix}-drp-rg-${var.environment}"
  location = var.primary_location
  tags = var.tags
}