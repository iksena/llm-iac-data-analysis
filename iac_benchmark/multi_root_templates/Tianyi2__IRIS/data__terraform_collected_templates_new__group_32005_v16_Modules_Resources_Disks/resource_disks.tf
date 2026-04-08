# Create managed disk
resource "azurerm_managed_disk" "disks" {
  count                = var.vm_data_disk_count
  name                 = "${var.resource_name}_DataDisk_${count.index + 1}"
  location             = var.resource_location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.vm_data_disk_size
  zones                = var.resource_zone != null ? [var.resource_zone] : null

  tags = {
    environment = var.resource_environment
  }
}

# Attach disks to virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "disks_attach" {
  count              = var.vm_data_disk_count
  managed_disk_id    = azurerm_managed_disk.disks[count.index].id
  virtual_machine_id = var.resource_virtual_machine_id
  lun                = count.index
  caching            = "ReadWrite"
}
