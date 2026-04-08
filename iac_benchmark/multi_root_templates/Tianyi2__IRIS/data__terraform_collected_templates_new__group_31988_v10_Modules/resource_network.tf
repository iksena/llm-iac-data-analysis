# Create virtual network
resource "azurerm_virtual_network" "vm_network" {
  name                = var.network_name
  address_space       = [var.network_address]
  resource_group_name = azurerm_resource_group.vm_group.name
  location            = azurerm_resource_group.vm_group.location
}

# Create network subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vm_group.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = cidrsubnets(var.network_address, 1)
}