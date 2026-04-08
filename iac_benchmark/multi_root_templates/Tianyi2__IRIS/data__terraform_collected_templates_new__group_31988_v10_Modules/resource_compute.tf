# Create availability set
resource "azurerm_availability_set" "vm_availability_set" {
  name                        = local.resource_name
  location                    = azurerm_resource_group.vm_group.location
  resource_group_name         = azurerm_resource_group.vm_group.name
  platform_fault_domain_count = var.vm_fault_domain

  tags = {
    environment = var.vm_environment
  }
}

# Create network adapter
resource "azurerm_network_interface" "vm_network_interface" {
  count               = var.resource_instance_count
  name                = "${local.resource_name}${count.index + 1}"
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
  count               = var.resource_instance_count
  name                = "${local.resource_name}${count.index + 1}"
  resource_group_name = azurerm_resource_group.vm_group.name
  location            = azurerm_resource_group.vm_group.location
  size                = var.resource_size
  admin_username      = var.admin_username
  admin_password      = random_password.vm_password[count.index].result
  license_type        = "Windows_Server"
  network_interface_ids = [
    azurerm_network_interface.vm_network_interface[count.index].id,
  ]

  availability_set_id = azurerm_availability_set.vm_availability_set.id

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
