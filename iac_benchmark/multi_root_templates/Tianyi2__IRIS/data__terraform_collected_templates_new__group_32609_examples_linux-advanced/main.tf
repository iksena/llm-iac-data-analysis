terraform {
  required_version = ">= 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}

module "des" {
  source                    = "github.com/schubergphilis/terraform-azure-mcaf-diskencryptionset?ref=v0.1.0"
  name                      = "testdes"
  resource_group_name       = "test-rg"
  location                  = "westeurope"
  key_vault_key_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-kv/keys/test-key"
  key_vault_resource_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-kv"
  auto_key_rotation_enabled = true
  managed_identities = {
    system_assigned = true
  }
}

module "vm" {
  source = "../../"

  name                = "testlinvm"
  location            = "westeurope"
  resource_group_name = "test-rg"
  sku_size            = "Standard_D2as_v5"
  admin_username      = "Godmode123"
  zone                = "3"
  network_interfaces = {
    network_interface_1 = {
      name = "vm-nic1"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "testwinvm-ipconfig1"
          private_ip_subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
          is_primary_ipconfiguration    = true
          load_balancer_backend_pools = {
            lb_pool_1 = {
              load_balancer_backend_pool_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/loadBalancers/test-lb/backendAddressPools/test-pool"
            }
          }
          load_balancer_nat_rules = {
            lb_nat_rule_1 = {
              load_balancer_nat_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/loadBalancers/test-lb/inboundNatRules/test-natrule"
            }
          }
        },
        ip_configuration_2 = {
          name                          = "testwinvm-ipconfig2"
          private_ip_subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/other-subnet"
          is_primary_ipconfiguration    = false
        }
      }
    },
    network_interface_2 = {
      name = "vm-nic2"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "testwinvm-ipconfig2"
          private_ip_subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/other-subnet"
        }
      }
    }
  }

  admin_ssh_keys = [
    {
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfZz3"
      username   = "Godmode123"
    },
    {
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfZz4"
      username   = "Godmode456"
    }
  ]

  os_type = "Linux"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = filebase64("cloudinit/cloud-init.sh")

  os_disk = {
    name                   = "testlinvm-osdisk"
    size_gb                = 128
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_encryption_set_id = module.des.resource_id
  }

  data_disk_managed_disks = {
    data_disk_1 = {
      name                   = "testlinvm-datadisk1"
      caching                = "Read"
      storage_account_type   = "Premium_LRS"
      disk_size_gb           = 512
      lun                    = 0
      disk_encryption_set_id = module.des.resource_id
    },
    data_disk_2 = {
      name                   = "testlinvm-datadisk2"
      caching                = "None"
      storage_account_type   = "Standard_LRS"
      disk_size_gb           = 512
      lun                    = 1
      disk_encryption_set_id = module.des.resource_id
    }
  }

  tags = {
    environment = "dev"
  }

  role_assignments = {
    vm_admin_login = {
      role_definition_id_or_name = "Virtual Machine Administrator Login"
      principal_id               = "00000-0000-0000-0000-000000000000"
    }
  }
}
