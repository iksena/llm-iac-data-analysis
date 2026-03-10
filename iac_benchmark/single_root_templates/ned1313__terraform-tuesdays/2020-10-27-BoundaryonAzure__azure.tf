# ── variables.tf ────────────────────────────────────
variable "location" {
  type    = string
  default = "East US"
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
    "workers",
    "backend",
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
  default = 1
}

variable "db_username" {
  type    = string
  default = "sqladmin"
}

variable "db_password" {
  type    = string
  default = "B0un4aryPGAdm!n"
}

variable "cert_cn" {
  type    = string
  default = "boundary-azure"
}

variable "cert_san" {
  type    = list(string)
  default = ["boundary-azure.example.com"]
}

resource "random_id" "id" {
  byte_length = 4
}

locals {
  resource_group_name = "boundary-${random_id.id.hex}"

  controller_net_nsg = "controller-net-${random_id.id.hex}"
  worker_net_nsg     = "worker-net-${random_id.id.hex}"
  backend_net_nsg    = "backend-net-${random_id.id.hex}"

  controller_nic_nsg = "controller-nic-${random_id.id.hex}"
  worker_nic_nsg     = "worker-nic-${random_id.id.hex}"
  backend_nic_nsg    = "backend-nic-${random_id.id.hex}"

  controller_asg = "controller-asg-${random_id.id.hex}"
  worker_asg     = "worker-asg-${random_id.id.hex}"

  controller_vm = "controller-${random_id.id.hex}"
  worker_vm     = "worker-${random_id.id.hex}"

  controller_user_id = "controller-userid-${random_id.id.hex}"
  worker_user_id     = "worker-userid-${random_id.id.hex}"

  pip_name = "boundary-${random_id.id.hex}"
  lb_name  = "boundary-${random_id.id.hex}"

  vault_name = "boundary-${random_id.id.hex}"

  pg_name = "boundary-${random_id.id.hex}"

}


# ── outputs.tf ────────────────────────────────────
output "vault_name" {
    value = local.vault_name
}

output "tenant_id" {
    value = data.azurerm_client_config.current.tenant_id
}

output "controller_url" {
    value = "https://${azurerm_public_ip.boundary.fqdn}:9200"
}

output "target_ips" {
    value = ""
}

# ── keyvault.tf ────────────────────────────────────

# Get your current IP address
data "http" "my_ip" {
  url = "http://ifconfig.me"
}

# Create key vault and access policy for worker and controller nodes
resource "azurerm_key_vault" "boundary" {
  name                       = local.vault_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.boundary.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment     = true
  soft_delete_enabled        = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = ["${data.http.my_ip.body}/32"]
    virtual_network_subnet_ids = [module.vnet.vnet_subnets[0],module.vnet.vnet_subnets[1]]

  }

}

resource "azurerm_key_vault_access_policy" "controller" {
  key_vault_id = azurerm_key_vault.boundary.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.controller.principal_id

  key_permissions = [
    "get", "list", "update", "create", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify", "sign",
  ]

  secret_permissions = [
    "get", "list",
  ]

  certificate_permissions = [
    "get", "list",
  ]
}

resource "azurerm_key_vault_access_policy" "worker" {
  key_vault_id = azurerm_key_vault.boundary.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.worker.principal_id

  key_permissions = [
    "get", "list", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify", "sign",
  ]

  secret_permissions = [
    "get", "list",
  ]

  certificate_permissions = [
    "get", "list",
  ]
}

resource "azurerm_key_vault_access_policy" "you" {
  key_vault_id = azurerm_key_vault.boundary.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get", "list", "update", "create", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify", "sign",
  ]

  secret_permissions = [
    "get", "list", "set", "delete",
  ]

  certificate_permissions = [
    "get", "list", "create", "import", "delete", "update",
  ]
}

# Create three keys for root, recovery, and worker
resource "azurerm_key_vault_key" "keys" {
  for_each     = toset(["root", "worker", "recovery"])
  name         = each.key
  key_vault_id = azurerm_key_vault.boundary.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

# Create a certificate
resource "azurerm_key_vault_certificate" "boundary" {
  name         = "boundary"
  key_vault_id = azurerm_key_vault.boundary.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]

      key_usage = [
        "digitalSignature",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = var.cert_san
      }

      subject            = "CN=${var.cert_cn}"
      validity_in_months = 12
    }
  }
}

# ── lb.tf ────────────────────────────────────
resource "azurerm_public_ip" "boundary" {
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.boundary.name
  location            = azurerm_resource_group.boundary.location
  allocation_method   = "Static"
  domain_name_label = lower(azurerm_resource_group.boundary.name)
  sku = "Standard"
}

resource "azurerm_lb" "boundary" {
  name                = local.lb_name
  location            = azurerm_resource_group.boundary.location
  resource_group_name = azurerm_resource_group.boundary.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.boundary.id
  }
}

resource "azurerm_lb_backend_address_pool" "pools" {
  for_each            = toset(["controller", "worker"])
  resource_group_name = azurerm_resource_group.boundary.name
  loadbalancer_id     = azurerm_lb.boundary.id
  name                = each.key
}

resource "azurerm_network_interface_backend_address_pool_association" "controller" {
  count                   = var.controller_vm_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.pools["controller"].id
  ip_configuration_name   = "internal"
  network_interface_id    = azurerm_network_interface.controller[count.index].id
}

resource "azurerm_network_interface_backend_address_pool_association" "worker" {
  count                   = var.controller_vm_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.pools["worker"].id
  ip_configuration_name   = "internal"
  network_interface_id    = azurerm_network_interface.worker[count.index].id
}

resource "azurerm_lb_probe" "controller_9200" {
  resource_group_name = azurerm_resource_group.boundary.name
  loadbalancer_id     = azurerm_lb.boundary.id
  name                = "port-9200"
  port                = 9200
}

resource "azurerm_lb_probe" "worker_9202" {
  resource_group_name = azurerm_resource_group.boundary.name
  loadbalancer_id     = azurerm_lb.boundary.id
  name                = "port-9202"
  port                = 9202
}

resource "azurerm_lb_rule" "controller" {
  resource_group_name            = azurerm_resource_group.boundary.name
  loadbalancer_id                = azurerm_lb.boundary.id
  name                           = "Controller"
  protocol                       = "Tcp"
  frontend_port                  = 9200
  backend_port                   = 9200
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id = azurerm_lb_probe.controller_9200.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.pools["controller"].id
}

resource "azurerm_lb_rule" "worker" {
  resource_group_name            = azurerm_resource_group.boundary.name
  loadbalancer_id                = azurerm_lb.boundary.id
  name                           = "Worker"
  protocol                       = "Tcp"
  frontend_port                  = 9202
  backend_port                   = 9202
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id = azurerm_lb_probe.worker_9202.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.pools["worker"].id
}



# ── nsg.tf ────────────────────────────────────
# Inbound rules for controller subnet nsg

resource "azurerm_network_security_rule" "controller_9200" {
  name                        = "allow_9200"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9200"
  source_address_prefix       = "*"
  destination_application_security_group_ids  = [azurerm_application_security_group.controller_asg.id]
  resource_group_name         = azurerm_resource_group.boundary.name
  network_security_group_name = azurerm_network_security_group.controller_net.name
}

resource "azurerm_network_security_rule" "controller_9201" {
  name                        = "allow_9201"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9201"
  source_application_security_group_ids      = [azurerm_application_security_group.worker_asg.id]
  destination_application_security_group_ids  = [azurerm_application_security_group.controller_asg.id]
  resource_group_name         = azurerm_resource_group.boundary.name
  network_security_group_name = azurerm_network_security_group.controller_net.name
}

# Inbound rules for controller nic nsg

resource "azurerm_network_security_rule" "controller_nic_9200" {
  name                        = "allow_9200"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9200"
  source_address_prefix       = "*"
  destination_application_security_group_ids  = [azurerm_application_security_group.controller_asg.id]
  resource_group_name         = azurerm_resource_group.boundary.name
  network_security_group_name = azurerm_network_security_group.controller_nics.name
}

resource "azurerm_network_security_rule" "controller_nic_9201" {
  name                        = "allow_9201"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9201"
  source_application_security_group_ids      = [azurerm_application_security_group.worker_asg.id]
  destination_application_security_group_ids  = [azurerm_application_security_group.controller_asg.id]
  resource_group_name         = azurerm_resource_group.boundary.name
  network_security_group_name = azurerm_network_security_group.controller_nics.name
}

# Inbound rules for worker subnet nsg

resource "azurerm_network_security_rule" "worker_9202" {
  name                        = "allow_9202"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9202"
  source_address_prefix       = "*"
  destination_application_security_group_ids  = [azurerm_application_security_group.worker_asg.id]
  resource_group_name         = azurerm_resource_group.boundary.name
  network_security_group_name = azurerm_network_security_group.worker_net.name
}

# Inbound rules for worker nic nsg

resource "azurerm_network_security_rule" "worker_nic_9202" {
  name                        = "allow_9202"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9202"
  source_address_prefix       = "*"
  destination_application_security_group_ids  = [azurerm_application_security_group.worker_asg.id]
  resource_group_name         = azurerm_resource_group.boundary.name
  network_security_group_name = azurerm_network_security_group.worker_nics.name
}

# Inbound rules for backend subnet nsg

# None for right now

# ── postgres.tf ────────────────────────────────────
# Create postgresql server
# Make sure to allow Azure services
resource "azurerm_postgresql_server" "boundary" {
  name                = local.pg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  sku_name   = "B_Gen5_2"
  version    = "11"
  storage_mb = 51200

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

}

resource "azurerm_postgresql_firewall_rule" "boundary" {
  name                = "AllowaccesstoAzureservices"
  resource_group_name = azurerm_resource_group.boundary.name
  server_name         = azurerm_postgresql_server.boundary.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}


# ── vm.tf ────────────────────────────────────
# Generate key pair for all VMs
resource "tls_private_key" "boundary" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Write private key out to a file
resource "local_file" "private_key" {
  content  = tls_private_key.boundary.private_key_pem
  filename = "${path.root}/azure_vms_private_key.pem"
}

# Create User Identities for Controller VMs and Worker VMs
resource "azurerm_user_assigned_identity" "controller" {
  resource_group_name = azurerm_resource_group.boundary.name
  location            = var.location

  name = local.controller_user_id
}

resource "azurerm_user_assigned_identity" "worker" {
  resource_group_name = azurerm_resource_group.boundary.name
  location            = var.location

  name = local.worker_user_id
}

##################### CONTROLLER VM RESOURCES ###################################
resource "azurerm_availability_set" "controller" {
  name                         = local.controller_vm
  location                     = var.location
  resource_group_name          = azurerm_resource_group.boundary.name
  platform_fault_domain_count  = 3
  platform_update_domain_count = 2
  managed                      = true
}


resource "azurerm_network_interface" "controller" {
  count               = var.controller_vm_count
  name                = "${local.controller_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "controller" {
  count                     = var.controller_vm_count
  network_interface_id      = azurerm_network_interface.controller[count.index].id
  network_security_group_id = azurerm_network_security_group.controller_nics.id
}

resource "azurerm_network_interface_application_security_group_association" "controller" {
  count                         = var.controller_vm_count
  network_interface_id          = azurerm_network_interface.controller[count.index].id
  application_security_group_id = azurerm_application_security_group.controller_asg.id
}

data "template_file" "controller" {
  template = file("${path.module}/boundary.tmpl")

  vars = {
    vault_name  = local.vault_name
    type = "controller"
    name = "boundary"
    tenant_id   = data.azurerm_client_config.current.tenant_id
    db_username = var.db_username
    db_password = var.db_password
    db_endpoint = azurerm_postgresql_server.boundary.fqdn
    db_name = local.pg_name
    public_ip    = azurerm_public_ip.boundary.ip_address
    controller_ips = join(",",azurerm_network_interface.controller[*].private_ip_address)
  }
}

resource "azurerm_linux_virtual_machine" "controller" {
  count               = var.controller_vm_count
  name                = "${local.controller_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
  size                = var.controller_vm_size
  admin_username      = "azureuser"
  computer_name       = "controller-${count.index}"
  availability_set_id = azurerm_availability_set.controller.id
  network_interface_ids = [
    azurerm_network_interface.controller[count.index].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.boundary.public_key_openssh
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

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.controller.id]
  }

  secret {
    key_vault_id = azurerm_key_vault.boundary.id

    certificate {
      url = azurerm_key_vault_certificate.boundary.secret_id
    }
  }

  custom_data = base64encode(data.template_file.controller.rendered)
}

##################### WORKER VM RESOURCES ###################################

resource "azurerm_network_interface" "worker" {
  count               = var.worker_vm_count
  name                = "${local.worker_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[1]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "worker" {
  count                     = var.worker_vm_count
  network_interface_id      = azurerm_network_interface.worker[count.index].id
  network_security_group_id = azurerm_network_security_group.worker_nics.id
}

resource "azurerm_network_interface_application_security_group_association" "worker" {
  count                         = var.worker_vm_count
  network_interface_id          = azurerm_network_interface.worker[count.index].id
  application_security_group_id = azurerm_application_security_group.worker_asg.id
}

data "template_file" "worker" {
  template = file("${path.module}/boundary.tmpl")

  vars = {
    vault_name     = local.vault_name
    type           = "worker"
    name = "boundary"
    tenant_id      = data.azurerm_client_config.current.tenant_id
    public_ip    = azurerm_public_ip.boundary.ip_address
    controller_ips = join(",",azurerm_network_interface.controller[*].private_ip_address)
    db_username = var.db_username
    db_password = var.db_password
    db_name = local.pg_name
    db_endpoint = azurerm_postgresql_server.boundary.fqdn
  }
}

resource "azurerm_linux_virtual_machine" "worker" {
  count               = var.worker_vm_count
  name                = "${local.worker_vm}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
  size                = var.worker_vm_size
  admin_username      = "azureuser"
  computer_name       = "worker-${count.index}"
  availability_set_id = azurerm_availability_set.controller.id
  network_interface_ids = [
    azurerm_network_interface.worker[count.index].id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.boundary.public_key_openssh
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

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.worker.id]
  }

  secret {
    key_vault_id = azurerm_key_vault.boundary.id

    certificate {
      url = azurerm_key_vault_certificate.boundary.secret_id
    }
  }

  custom_data = base64encode(data.template_file.worker.rendered)

  depends_on = [azurerm_linux_virtual_machine.controller]
}

# ── vnet.tf ────────────────────────────────────
# Define provider for config
provider "azurerm" {
  version = "~> 2.0"
  features {}
}

# Used to get tenant ID as needed
data "azurerm_client_config" "current" {}

# Resource group for ALL resources
resource "azurerm_resource_group" "boundary" {
  name     = local.resource_group_name
  location = var.location
}

# Virtual network with three subnets for controller, workers, and backends
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version = "~> 2.0"
  resource_group_name = azurerm_resource_group.boundary.name
  vnet_name = azurerm_resource_group.boundary.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names

  subnet_service_endpoints = {
      (var.subnet_names[0]) = ["Microsoft.KeyVault"]
      (var.subnet_names[1]) = ["Microsoft.KeyVault"]
  }
}

# Create Network Security Groups for subnets
resource "azurerm_network_security_group" "controller_net" {
  name                = local.controller_net_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

resource "azurerm_network_security_group" "worker_net" {
  name                = local.worker_net_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

resource "azurerm_network_security_group" "backend_net" {
  name                = local.backend_net_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

# Create NSG associations
resource "azurerm_subnet_network_security_group_association" "controller" {
  subnet_id                 = module.vnet.vnet_subnets[0]
  network_security_group_id = azurerm_network_security_group.controller_net.id
}

resource "azurerm_subnet_network_security_group_association" "worker" {
  subnet_id                 = module.vnet.vnet_subnets[1]
  network_security_group_id = azurerm_network_security_group.worker_net.id
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = module.vnet.vnet_subnets[2]
  network_security_group_id = azurerm_network_security_group.backend_net.id
}

# Create Network Security Groups for NICs

resource "azurerm_network_security_group" "controller_nics" {
  name                = local.controller_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

resource "azurerm_network_security_group" "worker_nics" {
  name                = local.worker_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

resource "azurerm_network_security_group" "backend_nics" {
  name                = local.backend_nic_nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

# Create application security groups for controllers and workers

resource "azurerm_application_security_group" "controller_asg" {
  name                = local.controller_asg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}

resource "azurerm_application_security_group" "worker_asg" {
  name                = local.worker_asg
  location            = var.location
  resource_group_name = azurerm_resource_group.boundary.name
}