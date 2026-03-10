# ── main.tf ────────────────────────────────────
provider "azuread" {
  version = "=0.7.0"
}

provider "random" {
  version = "=2.2.1"
}

provider "null" {
  version = "=2.1.2"
}

resource "azurerm_resource_group" "network" {
  name     = "${var.resource_name_prefix}-network-rgroup"
  location = var.location
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.resource_name_prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.137.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_name_prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.network.name
  resource_group_name  = azurerm_resource_group.network.name
  address_prefix       = "10.137.1.0/24"
  service_endpoints    = ["Microsoft.KeyVault"]

  lifecycle {
    ignore_changes = [
      network_security_group_id,
      route_table_id
    ]
  }
}

resource "azurerm_resource_group" "storage" {
  name     = "${var.resource_name_prefix}-storage-rgroup"
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                      = "${var.resource_name_prefix}storage"
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "storage" {
  name                  = "${var.resource_name_prefix}container"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "a_file" {
  name                   = "hello.txt"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.storage.name
  type                   = "Block"
  source_content         = "Hello, Blob!"
}


# ── variables.tf ────────────────────────────────────
variable "resource_name_prefix" {
  type    = string
  default = "trylayers"
}

variable "location" {
  type    = string
  default = "westeurope"
}


# ── layers.tf ────────────────────────────────────
/*
    You may need service principals for eg. managing access to Key Vault.
    However, that requires privileges to manage AD, which is outside of focus of this example.

resource "null_resource" "service_principal_layer" {
  provisioner "local-exec" {
    command = "echo === Created all Service Principals"
  }

  depends_on = [
    azuread_service_principal.keyvault_sp,
    azuread_service_principal_password.keyvault_sp_password
  ]
}
*/

resource "null_resource" "resource_group_layer" {
  provisioner "local-exec" {
    command = "echo === Created all resource groups"
  }

  depends_on = [
    # null_resource.service_principal_layer,
    azurerm_resource_group.network,
    azurerm_resource_group.storage
  ]
}

resource "null_resource" "network_layer" {
  provisioner "local-exec" {
    command = "echo === Created all virtual networks"
  }

  depends_on = [
    null_resource.resource_group_layer,
    azurerm_virtual_network.network
  ]
}

resource "null_resource" "subnet_layer" {
  provisioner "local-exec" {
    command = "echo === Created all subnets"
  }

  depends_on = [
    null_resource.network_layer,
    azurerm_subnet.subnet
  ]
}

resource "null_resource" "monitoring_layer" {
  provisioner "local-exec" {
    command = "echo === Created monitoring components"
  }

  depends_on = [
    null_resource.subnet_layer,
    # monitoring is a bit out of scope, but it would go here
  ]
}

resource "null_resource" "storage_layer" {
  provisioner "local-exec" {
    command = "echo === Created storages"
  }
  depends_on = [
    null_resource.monitoring_layer,
    azurerm_storage_account.storage
  ]
}

/*
Resources outside layers can be created by not targeting anything
once the layers have been created.

Resources can use depends_on to ensure associated layers have been created for them.
*/
