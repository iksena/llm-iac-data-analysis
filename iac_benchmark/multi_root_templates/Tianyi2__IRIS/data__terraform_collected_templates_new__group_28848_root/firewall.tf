resource "azurerm_firewall" "firewall" {
  name                = "firewall"
  location            = azurerm_virtual_network.hub-vnet.location
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  ip_configuration {
    name                 = "firewall_config"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.firewall-ip.id
  }
}