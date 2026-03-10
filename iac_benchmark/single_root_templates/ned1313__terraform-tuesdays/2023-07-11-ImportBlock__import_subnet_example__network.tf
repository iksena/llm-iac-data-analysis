# ── main.tf ────────────────────────────────────
resource "azurerm_virtual_network" "main" {
  resource_group_name = var.resource_group_name
  location            = var.azure_region
  name                = var.vnet_name

  address_space = var.address_space
}

resource "azurerm_subnet" "main" {
  for_each             = var.subnets
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  name                 = each.key
  virtual_network_name = azurerm_virtual_network.main.name

  address_prefixes = [each.value]
}

# ── variables.tf ────────────────────────────────────
variable "azure_region" {
  type        = string
  description = "Region of Azure to use for resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group to use."
}

variable "vnet_name" {
  type        = string
  description = "Name of virtual network to create."
}

variable "address_space" {
  type        = list(string)
  description = "List of address spaces to use with virtual network."
}

variable "subnets" {
  type        = map(string)
  description = "Name of subnet and address prefix"
}

# ── outputs.tf ────────────────────────────────────
output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_ids" {
  value = [for subnet in azurerm_subnet.main : subnet.id]
}