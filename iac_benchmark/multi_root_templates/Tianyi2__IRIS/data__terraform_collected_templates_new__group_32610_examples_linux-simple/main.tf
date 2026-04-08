terraform {
  required_version = ">= 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}

module "vm" {
  source = "../../"

  name                = "testlinvm"
  location            = "westeurope"
  resource_group_name = "test-rg"
  sku_size            = "Standard_D2as_v5"
  admin_username      = "Godmode123"
  zone                = "1"
  network_interfaces = {
    network_interface_1 = {
      name = "vm-nic1"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "testlinvm-ipconfig1"
          private_ip_subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
        }
      }
    }
  }

  admin_ssh_keys = [
    {
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfZz3"
      username   = "Godmode123"
    }
  ]

  os_type = "Linux"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
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
