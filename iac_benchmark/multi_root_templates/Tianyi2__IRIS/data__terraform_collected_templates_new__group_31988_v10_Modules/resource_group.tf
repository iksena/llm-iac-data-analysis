# Create resource group
resource "azurerm_resource_group" "vm_group" {
  name     = local.resource_group_name
  location = var.resource_location
}
