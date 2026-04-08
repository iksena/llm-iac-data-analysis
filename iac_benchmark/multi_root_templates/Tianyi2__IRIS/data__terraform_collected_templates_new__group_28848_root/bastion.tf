resource "azurerm_bastion_host" "bastion" {
  name                = "Bastion"
  location            = azurerm_virtual_network.hub-vnet.location
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  ip_configuration {
    name                 = "bastion-config"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-ip.id
  }
}