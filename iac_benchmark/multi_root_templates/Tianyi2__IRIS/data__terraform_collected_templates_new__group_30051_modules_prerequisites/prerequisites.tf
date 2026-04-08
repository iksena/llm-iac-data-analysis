# Resource group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# Storage account
resource "azurerm_storage_account" "storage_account" {
  name = var.storage_account_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

##############################################################
# Vnet with 2 subnets for Function app and private endpoints #
##############################################################

resource "azurerm_virtual_network" "env_vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}

# Subnet for Private Endpoints
resource "azurerm_subnet" "subnet_001" {
  depends_on                      = [azurerm_virtual_network.env_vnet]
  name                            = var.snet_001_name
  address_prefixes                = var.snet_001_prefixes
  virtual_network_name            = var.vnet_name
  resource_group_name             = var.resource_group_name
  default_outbound_access_enabled = true
}

# Subnet for Function App
resource "azurerm_subnet" "subnet_002" {
  depends_on                      = [azurerm_virtual_network.env_vnet]
  name                            = var.snet_002_name
  address_prefixes                = var.snet_002_prefixes
  virtual_network_name            = var.vnet_name
  resource_group_name             = var.resource_group_name
  default_outbound_access_enabled = true
  delegation {
    name = "datadog_subnet_delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions =  ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
