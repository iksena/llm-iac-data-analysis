resource "azurerm_virtual_network" "hub-vnet" {
  name                = "Hub-vnet"
  location            = "westus"
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  address_space       = ["10.1.0.0/16"]
  tags = {
    environment = "dev"
  }
}
resource "azurerm_virtual_network" "spoke-1-vnet" {
  name                = "spoke-1-vnet"
  location            = azurerm_resource_group.Hub-And-Spoke.location
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  address_space       = ["10.2.0.0/16"]
  tags = {
    environment = "dev"
  }
}
resource "azurerm_virtual_network" "spoke-2-vnet" {
  name                = "spoke-2-vnet"
  location            = azurerm_resource_group.Hub-And-Spoke.location
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  address_space       = ["10.3.0.0/16"]
  tags = {
    environment = "dev"
  }
}