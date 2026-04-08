resource "azurerm_network_security_group" "nsg" {
  name                = "NSG"
  resource_group_name = azurerm_resource_group.Hub-And-Spoke.name
  location            = azurerm_resource_group.Hub-And-Spoke.location
}
resource "azurerm_network_security_rule" "nsg-rule-1" {
  name                        = "NSG-Rule-1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Hub-And-Spoke.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "nsg-rule-2" {
  name                        = "NSG-Rule-2"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.Hub-And-Spoke.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
