# ── variables.tf ────────────────────────────────────
variable "location" {
  default = "eastus"
  type = string
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  type = list(string)
  default = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

variable "subnet_names" {
  type = list(string)
  default = [
    "controllers",
    "subnet2",
    "subnet3",
  ]
}

variable "controller_vm_size" {
  type    = string
  default = "Standard_D2as_v4"
}

variable "controller_vm_count" {
  type    = number
  default = 1
}

variable "worker_vm_size" {
  type    = string
  default = "Standard_D2as_v4"
}

variable "worker_vm_count" {
  type    = number
  default = 3
}

resource "random_id" "id" {
  byte_length = 4
}

locals {
  controller_nic_nsg = "controller-nic-${random_id.id.hex}"
  worker_nic_nsg     = "worker-nic-${random_id.id.hex}"
  controller_vm = "controller-${random_id.id.hex}"
  worker_vm     = "worker-${random_id.id.hex}"
}

# ── network.tf ────────────────────────────────────
terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.41.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "cka" {
    name = "cka"
    location = var.location
}

# Virtual network with three subnets for controller, workers, and backends
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version = "~> 2.0"
  resource_group_name = azurerm_resource_group.cka.name
  vnet_name = azurerm_resource_group.cka.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names

  depends_on = [ azurerm_resource_group.cka ]
}

# Create Network Security Groups for NICs

resource "azurerm_network_security_group" "controller_nics" {
  name                = local.controller_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.cka.name
}

resource "azurerm_network_security_group" "worker_nics" {
  name                = local.worker_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.cka.name
}

# ── nsgs.tf ────────────────────────────────────
resource "azurerm_network_security_rule" "controller_nic_ssh" {
  name                        = "allow_ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.cka.name
  network_security_group_name = azurerm_network_security_group.controller_nics.name
}

resource "azurerm_network_security_rule" "controller_nic_allow_worker" {
    name = "allow_worker"
    priority = 101
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = var.address_space[0]
    destination_address_prefix = "*"
    resource_group_name         = azurerm_resource_group.cka.name
  network_security_group_name = azurerm_network_security_group.controller_nics.name
}

resource "azurerm_network_security_rule" "worker_nic_ssh" {
  name                        = "allow_ssh_local"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.cka.name
  network_security_group_name = azurerm_network_security_group.worker_nics.name
}

resource "azurerm_network_security_rule" "worker_nic_allow_controller" {
    name = "allow_controller"
    priority = 101
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = var.address_space[0]
    destination_address_prefix = "*"
    resource_group_name         = azurerm_resource_group.cka.name
  network_security_group_name = azurerm_network_security_group.worker_nics.name
}



# ── vms.tf ────────────────────────────────────
# Generate key pair for all VMs
resource "tls_private_key" "cka" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Write private key out to a file
resource "local_file" "private_key" {
  content  = tls_private_key.cka.private_key_pem
  filename = "${path.root}/azure_vms_private_key.pem"
}

##################### CONTROLLER VM RESOURCES ###################################
resource "azurerm_availability_set" "controller" {
  name                         = local.controller_vm
  location                     = var.location
  resource_group_name          = azurerm_resource_group.cka.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_public_ip" "controller" {
    count               = var.controller_vm_count
    name = "controllerPublicIP-${count.index}"
    resource_group_name = azurerm_resource_group.cka.name
    location = var.location
    allocation_method = "Static"
    sku = "Standard"
}


resource "azurerm_network_interface" "controller" {
  count               = var.controller_vm_count
  name                = "${local.controller_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.cka.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.controller[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "controller" {
  count                     = var.controller_vm_count
  network_interface_id      = azurerm_network_interface.controller[count.index].id
  network_security_group_id = azurerm_network_security_group.controller_nics.id
}

resource "azurerm_linux_virtual_machine" "controller" {
  count               = var.controller_vm_count
  name                = "${local.controller_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.cka.name
  size                = var.controller_vm_size
  admin_username      = "azureuser"
  computer_name       = "controller-${count.index}"
  availability_set_id = azurerm_availability_set.controller.id
  network_interface_ids = [
    azurerm_network_interface.controller[count.index].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.cka.public_key_openssh
  }

  # Using Standard SSD tier storage
  # Accepting the standard disk size from image
  # No data disk is being used
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

}

##################### WORKER VM RESOURCES ###################################

resource "azurerm_network_interface" "worker" {
  count               = var.worker_vm_count
  name                = "${local.worker_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.cka.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "worker" {
  count                     = var.worker_vm_count
  network_interface_id      = azurerm_network_interface.worker[count.index].id
  network_security_group_id = azurerm_network_security_group.worker_nics.id
}

resource "azurerm_linux_virtual_machine" "worker" {
  count               = var.worker_vm_count
  name                = "${local.worker_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.cka.name
  size                = var.worker_vm_size
  admin_username      = "azureuser"
  computer_name       = "worker-${count.index}"
  availability_set_id = azurerm_availability_set.controller.id
  network_interface_ids = [
    azurerm_network_interface.worker[count.index].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.cka.public_key_openssh
  }

  # Using Standard SSD tier storage
  # Accepting the standard disk size from image
  # No data disk is being used
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

}