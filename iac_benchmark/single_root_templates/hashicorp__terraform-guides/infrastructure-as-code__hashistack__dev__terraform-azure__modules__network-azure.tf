# ── main.tf ────────────────────────────────────
terraform {
  required_version = ">= 0.10.1"
}

module "images" {
  source = "../images-azure"

  os = "${var.os}"
}


# ── _interface.tf ────────────────────────────────────
# Required Variables
variable "environment_name" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "location" {
  type = "string"
}

variable "os" {
  type = "string"
}

variable "public_key_data" {
  type = "string"
}

# Optional Variables
variable "network_cidr" {
  default = "172.31.0.0/16"
}

variable "network_cidrs_public" {
  default = [
    "172.31.0.0/20",
    "172.31.16.0/20",
    "172.31.32.0/20",
  ]
}

variable "network_cidrs_private" {
  default = [
    "172.31.48.0/20",
    "172.31.64.0/20",
    "172.31.80.0/20",
  ]
}

variable "jumphost_vm_size" {
  default     = "Standard_A0"
  description = "Azure virtual machine size for jumphost"
}

# Outputs
output "jumphost_ips_public" {
  value = ["${azurerm_public_ip.jumphost.*.ip_address}"]
}

output "jumphost_username" {
  value = "${module.images.os_user}"
}

output "subnet_public_ids" {
  value = ["${azurerm_subnet.public.*.id}"]
}

output "subnet_private_ids" {
  value = ["${azurerm_subnet.private.*.id}"]
}


# ── firewalls-jumphost.tf ────────────────────────────────────
resource "azurerm_network_security_group" "jumphost" {
  name                = "${var.environment_name}-jumphost"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "jumphost_ssh" {
  name                        = "${var.environment_name}-jumphost-ssh"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.jumphost.name}"

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "22"
  destination_address_prefix = "*"
}


# ── instances-jumphost.tf ────────────────────────────────────
resource "azurerm_virtual_machine" "jumphost" {
  count = "${length(var.network_cidrs_public)}"

  name                  = "${var.environment_name}-jumphost-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${element(azurerm_network_interface.jumphost.*.id,count.index)}"]
  vm_size               = "${var.jumphost_vm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${module.images.base_publisher}"
    offer     = "${module.images.base_offer}"
    sku       = "${module.images.base_sku}"
    version   = "${module.images.base_version}"
  }

  storage_os_disk {
    name              = "${var.environment_name}-jumphost-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.environment_name}-jumphost-${count.index}"
    admin_username = "${module.images.os_user}"
    admin_password = "none"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${module.images.os_user}/.ssh/authorized_keys"
      key_data = "${var.public_key_data}"
    }
  }

  tags {
    environment_name = "${var.environment_name}-jumphost-${count.index}"
  }
}

resource "azurerm_network_interface" "jumphost" {
  count = "${length(var.network_cidrs_public)}"

  name                = "${var.environment_name}-jumphost-${count.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  network_security_group_id = "${azurerm_network_security_group.jumphost.id}"

  ip_configuration {
    name                          = "${var.environment_name}-jumphost-${count.index}"
    subnet_id                     = "${element(azurerm_subnet.public.*.id,count.index)}"
    public_ip_address_id          = "${element(azurerm_public_ip.jumphost.*.id,count.index)}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_public_ip" "jumphost" {
  count = "${length(var.network_cidrs_public)}"

  name                         = "${var.environment_name}-jumphost-${count.index}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
}

resource "random_id" "jumphost" {
  count = "${length(var.network_cidrs_public)}"

  byte_length = 3
}


# ── networks.tf ────────────────────────────────────
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment_name}"
  address_space       = ["${var.network_cidr}"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}


# ── subnets.tf ────────────────────────────────────
resource "azurerm_subnet" "public" {
  count = "${length(var.network_cidrs_public)}"

  name                 = "${var.environment_name}-public-${count.index}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${element(var.network_cidrs_public,count.index)}"
}

resource "azurerm_subnet" "private" {
  count = "${length(var.network_cidrs_private)}"

  name                 = "${var.environment_name}-private-${count.index}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${element(var.network_cidrs_private,count.index)}"
}
