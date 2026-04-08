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

  name                = "testwinvm"
  os_type             = "Windows"
  location            = "westeurope"
  resource_group_name = "test-rg"
  sku_size            = "Standard_D2as_v5"
  admin_username      = "Godmode123"

  #admin_password = var.admin_password
  rotate_admin_state_password = true
  generate_admin_password     = true
  generated_secrets_key_vault_secret_config = {
    key_vault_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-kv"
  }

  zone = "2"
  network_interfaces = {
    network_interface_1 = {
      name = "vm-nic1"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "testwinvm-ipconfig1"
          private_ip_subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
          create_public_ip_address      = true
          public_ip_address_name        = "testwinvm-pipconfig1"
          is_primary_ipconfiguration    = true
          app_gateway_backend_pools = {
            app_gw_pool_1 = {
              app_gateway_backend_pool_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/applicationGateways/test-appgw/backendAddressPools/test-pool"
            }
          }
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

  os_disk = {
    name                   = "testwinvm-osdisk"
    caching                = "None"
    storage_account_type   = "Premium_LRS"
    disk_encryption_set_id = module.des.resource_id
  }

  data_disk_managed_disks = {
    data_disk_1 = {
      name                   = "testwinvm-datadisk1"
      caching                = "None"
      storage_account_type   = "Premium_LRS"
      disk_size_gb           = 1024
      lun                    = 0
      disk_encryption_set_id = module.des.resource_id
    },
    data_disk_2 = {
      name                   = "testwinvm-datadisk2"
      caching                = "None"
      storage_account_type   = "Premium_LRS"
      disk_size_gb           = 1024
      lun                    = 1
      disk_encryption_set_id = module.des.resource_id
    }
  }

  hotpatching_enabled = true
  patch_mode          = "AutomaticByPlatform"
  timezone            = "W. Europe Standard Time"

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition-hotpatch-smalldisk"
    version   = "latest"
  }

  managed_identities = {
    system_assigned = true
  }

  extensions = {
    entra_login = {
      # Requires a System Assigned Managed Identity
      name                       = "AADLoginForWindows"
      publisher                  = "Microsoft.Azure.ActiveDirectory"
      type                       = "AADLoginForWindows"
      type_handler_version       = "2.0"
      auto_upgrade_minor_version = true
    }
    azure_monitor_agent = {
      name                       = "AzureMonitorWindowsAgent"
      publisher                  = "Microsoft.Azure.Monitor"
      type                       = "AzureMonitorWindowsAgent"
      type_handler_version       = "1.2"
      auto_upgrade_minor_version = true
      automatic_upgrade_enabled  = true
      settings                   = null
    }
    azure_disk_encryption = {
      name                       = "AzureDiskEncryption"
      publisher                  = "Microsoft.Azure.Security"
      type                       = "AzureDiskEncryption"
      type_handler_version       = "2.2"
      auto_upgrade_minor_version = true
      settings                   = <<SETTINGS
          {
              "EncryptionOperation": "EnableEncryption",
              "KeyVaultURL": "https://test-kv.vault.azure.net/",
              "KeyVaultResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-kv",
              "KeyEncryptionAlgorithm": "RSA-OAEP",
              "VolumeType": "All"
          }
      SETTINGS
    }
  }

  shutdown_schedules = {
    test_schedule = {
      daily_recurrence_time = "1900"
      enabled               = true
      timezone              = "W. Europe Standard Time"
      notification_settings = {
        enabled         = true
        email           = "example@example.com;example2@example.com"
        time_in_minutes = "15"
        webhook_url     = "https://example-webhook-url.example.com"
      }
    }
  }

  additional_unattend_contents = [
    {
      content = "<FirstLogonCommands><SynchronousCommand><CommandLine>shutdown /r /t 0 /c \"initial reboot\"</CommandLine><Description>reboot</Description><Order>1</Order></SynchronousCommand></FirstLogonCommands>"
      setting = "FirstLogonCommands"
    }
  ]
  winrm_listeners = {
    listeners = [
      {
        protocol        = "Https"
        certificate_url = "https://keyvault.vault.azure.net/secrets/certificate-name"
      }
    ]
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
