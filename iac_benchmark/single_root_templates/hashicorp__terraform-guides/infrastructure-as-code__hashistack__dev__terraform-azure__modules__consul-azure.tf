# ── main.tf ────────────────────────────────────
terraform {
  required_version = ">= 0.10.1"
}

module "images" {
  source = "../images-azure"

  os = "${var.os}"
}


# ── _interface.tf ────────────────────────────────────
# Required variables
variable "resource_group_name" {
  description = "Azure Resource Group to provision resources into"
}

variable "environment_name" {
  description = "Environment name (used for tagging purposes)"
}

variable "location" {
  description = "Region to deploy consul cluster to, e.g. West US"
}

variable "cluster_size" {
  description = "Number of instances to launch in the cluster"
}

variable "consul_datacenter" {
  description = "Name to apply to the Consul cluster (used for tagging and auto-join purposes)"
}

variable "os" {
  type = "string"
}

variable "custom_image_id" {
  description = "The Azure managed image ID to use in the scale set"
}

variable "vm_size" {
  description = "Azure virtual machine size"
}

variable "network_cidrs_private" {
  type = "list"
}

variable "private_subnet_ids" {
  type        = "list"
  description = "ID(s) of pre-existing private subnet(s) ID where the scale set should be created"
}

variable "public_key_data" {
  type = "string"
}

variable "auto_join_subscription_id" {
  type = "string"
}

variable "auto_join_client_id" {
  type = "string"
}

variable "auto_join_client_secret" {
  type = "string"
}

variable "auto_join_tenant_id" {
  type = "string"
}

# Outputs
output "consul_private_ips" {
  value = ["${azurerm_network_interface.consul.*.private_ip_address}"]
}

output "os_user" {
  value = "${module.images.os_user}"
}


# ── instances-consul.tf ────────────────────────────────────
resource "azurerm_virtual_machine" "consul" {
  count = "${length(var.network_cidrs_private)}"

  name                  = "${var.consul_datacenter}-${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${element(azurerm_network_interface.consul.*.id,count.index)}"]
  vm_size               = "${var.vm_size}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${var.custom_image_id}"
  }

  storage_os_disk {
    name              = "${var.consul_datacenter}-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.consul_datacenter}-${count.index}"
    admin_username = "${module.images.os_user}"
    admin_password = "none"
    custom_data    = "${base64encode(data.template_file.init.rendered)}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${module.images.os_user}/.ssh/authorized_keys"
      key_data = "${var.public_key_data}"
    }
  }

  tags {
    environment_name  = "${var.environment_name}"
    consul_datacenter = "${var.consul_datacenter}"
  }
}

resource "azurerm_network_interface" "consul" {
  count = "${length(var.network_cidrs_private)}"

  name                = "${var.consul_datacenter}-${count.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "${var.consul_datacenter}-${count.index}"
    subnet_id                     = "${element(var.private_subnet_ids,count.index)}"
    private_ip_address_allocation = "dynamic"
  }

  tags {
    environment_name  = "${var.environment_name}"
    consul_datacenter = "${var.consul_datacenter}"
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/init-cluster.tpl")}"

  vars = {
    cluster_size                = "${var.cluster_size}"
    consul_datacenter           = "${var.consul_datacenter}"
    auto_join_subscription_id   = "${var.auto_join_subscription_id}"
    auto_join_tenant_id         = "${var.auto_join_tenant_id}"
    auto_join_client_id         = "${var.auto_join_client_id}"
    auto_join_secret_access_key = "${var.auto_join_client_secret}"
  }
}
