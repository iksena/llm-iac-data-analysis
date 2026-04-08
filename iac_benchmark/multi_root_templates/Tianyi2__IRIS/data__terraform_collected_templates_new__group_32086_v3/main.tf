terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.29.0"
    }
  }

  required_version = "~> 1.1.6"
}

provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "vm_group" {
  name     = var.resource_group_name
  location = var.resource_location
}

# Create virtual network
resource "azurerm_virtual_network" "vm_network" {
  name                = var.network_name
  address_space       = [var.network_address]
  resource_group_name = azurerm_resource_group.vm_group.name
  location            = azurerm_resource_group.vm_group.location
}

# Create network subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vm_group.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = [var.subnet_address]
}

# Create network adapter
resource "azurerm_network_interface" "vm_network_interface" {
  name                = var.vm_network_interface
  location            = azurerm_resource_group.vm_group.location
  resource_group_name = azurerm_resource_group.vm_group.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                  = var.resource_name
  resource_group_name   = azurerm_resource_group.vm_group.name
  location              = azurerm_resource_group.vm_group.location
  size                  = var.resource_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  license_type          = "Windows_Server"
  network_interface_ids = [azurerm_network_interface.vm_network_interface.id]

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = var.vm_disk_type
    disk_size_gb         = var.vm_disk_size
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.vm_sku
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = {
    environment = var.vm_environment
  }

}

variable "resource_group_name" {
  description = "Name of resource group"
  type        = string
  default     = "WebServices"
}

variable "resource_location" {
  description = "Location of resources"
  type        = string
  default     = "UK South"
}

variable "network_name" {
  description = "Name of network"
  type        = string
  default     = "WebServicesNetwork"
}

variable "subnet_name" {
  description = "Name of subnet"
  type        = string
  default     = "WebServicesSubnet"
}

variable "resource_name" {
  description = "Name of vm"
  type        = string
  default     = "WEB"
}

variable "resource_size" {
  description = "Size of vm"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_disk_size" {
  description = "Size of vm disk"
  type        = string
  default     = "32"
}

variable "vm_disk_type" {
  description = "Type of vm disk"
  type        = string
  default     = "Standard_LRS"
}

variable "vm_sku" {
  description = "Size of vm"
  type        = string
  default     = "2019-Datacenter-smalldisk"
}

variable "admin_username" {
  description = "Desired username for the provisioned resources"
  type        = string
  default     = "wesley"
}

variable "admin_password" {
  description = "Desired password for the provisioned resources"
  type        = string
  default     = "mnUuk2TOEVe1qh"
  sensitive   = true
}

variable "vm_environment" {
  description = "Environment of vm"
  type        = string
  default     = "Production"
}

variable "network_address" {
  description = "Network address space"
  type        = string
  default     = "10.0.0.0/22"
}

variable "subnet_address" {
  description = "Subnet prefix"
  type        = string
  default     = "10.0.0.0/24"
}

variable "vm_network_interface" {
  description = "Name of vm ni"
  type        = string
  default     = "Production"
}