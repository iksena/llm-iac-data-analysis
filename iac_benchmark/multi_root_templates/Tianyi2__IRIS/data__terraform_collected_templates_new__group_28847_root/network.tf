resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  dns_servers         = var.vnet_dns_servers
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_address_prefix
}
