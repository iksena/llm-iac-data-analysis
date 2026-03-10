# ── variables.tf ────────────────────────────────────
variable "region" {
  type        = string
  description = "Region in Azure"
  default     = "eastus"
}

variable "prefix" {
  type        = string
  description = "prefix for naming"
  default     = "tacos"
}

variable "hypervisor_vm_size" {
  type        = string
  description = "Size for VM, must be Dv3 or Ev3"
  default     = "Standard_D4s_v3"
}

variable "data_disk_size" {
  type        = number
  description = "Size of data disk for VMs"
  default     = 256
}

variable "data_disk_storage_class" {
  type        = string
  description = "Storage class for the data disk"
  default     = "Premium_LRS"
}

resource "random_id" "seed" {
  byte_length = 4
}

locals {
  name          = "${var.prefix}-${random_id.seed.hex}"
  hypervisor_vm = "hypervisor-${random_id.seed.hex}"
}

# ── outputs.tf ────────────────────────────────────
output "hypervisor_fqdn" {
  value = azurerm_public_ip.hypervisor.fqdn
}

output "hypervisor_public_ip" {
  value = azurerm_public_ip.hypervisor.ip_address
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"

    }
  }
}

provider "azurerm" {
  features {}
}

# ── vm.tf ────────────────────────────────────
resource "tls_private_key" "hypervisor" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Write private key out to a file
resource "local_file" "private_key" {
  content  = tls_private_key.hypervisor.private_key_pem
  filename = "${path.root}/azure_vms_private_key.pem"
}

resource "azurerm_availability_set" "hypervisor" {
  name                         = local.hypervisor_vm
  location                     = azurerm_resource_group.vnet.location
  resource_group_name          = azurerm_resource_group.vnet.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_public_ip" "hypervisor" {
  name                = "${local.hypervisor_vm}-primary"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = azurerm_resource_group.vnet.location
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  domain_name_label   = "${local.hypervisor_vm}-primary"
}

resource "azurerm_public_ip" "nested" {
  name                = "${local.hypervisor_vm}-nested"
  resource_group_name = azurerm_resource_group.vnet.name
  location            = azurerm_resource_group.vnet.location
  sku                 = "Basic"
  allocation_method   = "Dynamic"
  domain_name_label   = "${local.hypervisor_vm}-nested"
}

resource "azurerm_network_interface" "hypervisor" {
  name                = local.hypervisor_vm
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hypervisor.id
    primary                       = true
  }

  ip_configuration {
    name                          = "nested"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nested.id

  }
}

resource "azurerm_network_interface_security_group_association" "hypervisor" {
  network_interface_id      = azurerm_network_interface.hypervisor.id
  network_security_group_id = azurerm_network_security_group.hypervisor_nics.id
}

resource "azurerm_linux_virtual_machine" "hypervisor" {
  name                = local.hypervisor_vm
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  size                = var.hypervisor_vm_size
  admin_username      = "azureuser"
  computer_name       = local.hypervisor_vm
  availability_set_id = azurerm_availability_set.hypervisor.id
  network_interface_ids = [
    azurerm_network_interface.hypervisor.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.hypervisor.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }


  #Source image is hardcoded b/c I said so
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = filebase64("${path.module}/setup.tpl")
}

resource "azurerm_managed_disk" "hypervisor" {
  name                 = "${local.hypervisor_vm}-vms"
  location             = azurerm_resource_group.vnet.location
  resource_group_name  = azurerm_resource_group.vnet.name
  storage_account_type = var.data_disk_storage_class
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "hypervisor" {
  managed_disk_id    = azurerm_managed_disk.hypervisor.id
  virtual_machine_id = azurerm_linux_virtual_machine.hypervisor.id
  lun                = "3"
  caching            = "ReadWrite"
}

# ── vnet.tf ────────────────────────────────────
resource "azurerm_resource_group" "vnet" {
  name     = local.name
  location = var.region
}

# Create a vnet with a single subnet for the Azure VM
module "network" {
  source              = "Azure/network/azurerm"
  version             = "~> 3.0"
  resource_group_name = azurerm_resource_group.vnet.name
  vnet_name           = local.name
  address_space       = "10.0.0.0/16"
  subnet_prefixes     = ["10.0.0.0/24"]
  subnet_names        = ["hypervisors"]

  depends_on = [azurerm_resource_group.vnet]
}

# Create a network security group for the VM allowing SSH
resource "azurerm_network_security_group" "hypervisor_nics" {
  name                = local.hypervisor_vm
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_network_security_rule" "hypervisor_nic_ssh" {
  name                        = "allow_ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet.name
  network_security_group_name = azurerm_network_security_group.hypervisor_nics.name
}