resource "azurerm_virtual_network" "vnet_primary" {
  name                = "${var.project_prefix}-vnet-primary-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.rg_primary.name
  depends_on = [azurerm_resource_group.rg_primary]
  tags = var.tags
}

# Secondary vnet for database replication. Only for production environment

resource "azurerm_virtual_network" "vnet_secondary" {
  name                = "${var.project_prefix}-vnet-secondary-${var.environment}"
  address_space       = ["10.1.0.0/16"]
  location            = var.secondary_location
  resource_group_name = azurerm_resource_group.rg_secondary.name
  depends_on = [azurerm_resource_group.rg_secondary]
  tags = var.tags
}

# Virtual network peering
# VNet Peering from primary to secondary
resource "azurerm_virtual_network_peering" "vnet_peering_primary_to_secondary" {
  name                      = "${var.project_prefix}-primary-to-secondary-vnet-peering"
  resource_group_name       = azurerm_resource_group.rg_primary.name
  virtual_network_name      = azurerm_virtual_network.vnet_primary.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_secondary.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
  allow_virtual_network_access = true

  depends_on = [
    azurerm_virtual_network.vnet_primary,
    azurerm_virtual_network.vnet_secondary
  ]
}

# VNet Peering from secondary to primary
resource "azurerm_virtual_network_peering" "vnet_peering_secondary_to_primary" {
  name                      = "${var.project_prefix}-secondary-to-primary-vnet-peering"
  resource_group_name       = azurerm_resource_group.rg_secondary.name
  virtual_network_name      = azurerm_virtual_network.vnet_secondary.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_primary.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
  allow_virtual_network_access = true

  depends_on = [
    azurerm_virtual_network_peering.vnet_peering_primary_to_secondary
  ]
}