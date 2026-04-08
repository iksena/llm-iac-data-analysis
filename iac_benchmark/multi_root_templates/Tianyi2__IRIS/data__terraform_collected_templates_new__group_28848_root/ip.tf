resource "azurerm_public_ip" "bastion-ip" {
  name                = "bastion_ip"
  location            = azurerm_virtual_network.hub-vnet.location
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "firewall-ip" {
  name                = "firewall_ip"
  location            = azurerm_virtual_network.hub-vnet.location
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  allocation_method   = "Static"
  sku                 = "Standard"
}