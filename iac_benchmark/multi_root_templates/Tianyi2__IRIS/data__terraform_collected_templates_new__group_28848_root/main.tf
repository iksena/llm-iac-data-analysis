resource "azurerm_resource_group" "Hub-And-Spoke" {
  name     = "Hub-And-Spoke-rg"
  location = "eastus"
  tags = {
    environment = "dev"
  }
}
