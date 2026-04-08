resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.Hub-And-Spoke.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.1.1.224/27"]
}
resource "azurerm_subnet" "gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.Hub-And-Spoke.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.1.2.0/24"]
}
resource "azurerm_subnet" "firewall-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.Hub-And-Spoke.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.1.3.192/26"]
}
resource "azurerm_subnet" "nic-subnet-spoke-1" {
  name                 = "nic-subnet-spoke-1"
  resource_group_name  = azurerm_resource_group.Hub-And-Spoke.name
  virtual_network_name = azurerm_virtual_network.spoke-1-vnet.name
  address_prefixes     = ["10.2.1.0/24"]
}
resource "azurerm_subnet" "nic-subnet-spoke-2" {
  name                 = "nic-subnet-spoke-2"
  resource_group_name  = azurerm_resource_group.Hub-And-Spoke.name
  virtual_network_name = azurerm_virtual_network.spoke-2-vnet.name
  address_prefixes     = ["10.3.1.0/24"]
}