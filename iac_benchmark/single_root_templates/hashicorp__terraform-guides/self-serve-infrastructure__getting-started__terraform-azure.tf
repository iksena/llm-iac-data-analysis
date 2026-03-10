# ── main.tf ────────────────────────────────────
provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

resource "azurerm_resource_group" "demo_resource_group" {
  name     = "${var.rg_name}"
  location = "${var.rg_location}"
}

resource "azurerm_virtual_network" "demo_virtual_network" {
  name                = "${var.vn_name}"
  address_space       = ["${var.vn_address_space}"]
  location            = "${azurerm_resource_group.demo_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.demo_resource_group.name}"
}

resource "azurerm_subnet" "demo_subnet" {
  name                 = "${var.sb_name}"
  resource_group_name  = "${azurerm_resource_group.demo_virtual_network.name}"
  virtual_network_name = "${azurerm_virtual_network.demo_virtual_network.name}"
  address_prefix       = "${var.sb_address_prefix}"
}


# ── outputs.tf ────────────────────────────────────
output "resource_group_consumable" {
  value       = "${azurerm_resource_group.demo_resource_group.name}"
  description = "The Demo VPC Name for later use"
}

output "virtual_network_consumable_name" {
  value       = "${azurerm_virtual_network.demo_virtual_network.name}"
  description = "The Demo Virtaul Network name for later use"
}

output "virtual_network_consumable_address_space" {
  value       = "${azurerm_virtual_network.demo_virtual_network.address_space}"
  description = "The Demo Virtaul Network address space for later use"
}

output "subnet_consumable" {
  value       = "${azurerm_subnet.demo_subnet.address_prefix}"
  description = "The Demo Subnet for later use"
}


# ── _interface.tf ────────────────────────────────────
variable "rg_name" {
  default     = ""
  description = "The default name for the Resource Group"
}

variable "rg_location" {
  default     = ""
  description = "The default name for the Resource Group"
}

variable "vn_name" {
  default     = ""
  description = "The default name for the Virtual Network"
}

variable "vn_address_space" {
  default     = ""
  description = "The default address space for the Virtual Network"
}

variable "sb_name" {
  default     = ""
  description = "The default name for the subnet"
}

variable "sb_address_prefix" {
  default     = ""
  description = "The default address prefix for the Subnet"
}
