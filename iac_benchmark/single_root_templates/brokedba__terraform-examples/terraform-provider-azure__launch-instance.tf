# ── variables.tf ────────────────────────────────────
# Azure account region and authentication 

variable "prefix" {
  description = "The prefix used for all resources in this example"
  default = "TerraDemo"
}
variable "az_location" {
    default = "eastus"
}
# VPC INFO
    variable "vnet_name" {
      default = "Terravnet"
    }
    
    variable "vnet_cidr" {
      default = "192.168.0.0/16"
    }

# SUBNET INFO
    variable "subnet_name"{
      default = "terrasub" 
      }

    variable "subnet_cidr"{
      default = "192.168.10.0/24"
      } 
    variable "sg_name" {
    default = "terra_sg"
    }
   

# COMPUTE INSTANCE INFO

      variable "instance_name" {
        default = "TerraCompute"
      }


      variable "osdisk_size" {
        default = "30"
      }
      variable "vm_size" {
        default = "Standard_B1s"
      }

variable  "os_publisher" {
  default = {
    CENTOS7 = {
           publisher = "OpenLogic"
           offer     = "CentOS"
           sku       = "7.7"
           admin     = "centos"
        },
    RHEL7  =  {
          publisher = "RedHat"
          offer     = "RHEL"
          sku       = "7lvm-gen2"
          admin     = "azureuser"
        },
    OL7    =  {
          publisher = "Oracle"
          offer     = "racle-Linux"
          sku       = "ol77-ci-gen2"
        },     
    WINDOWS    =  {
          publisher = "MicrosoftWindowsServer"
          offer     = "WindowsServer"
          sku       = "2016-Datacenter"
          admin     = "azureuser"
        },
    SUSE       =  {
          publisher = "SUSE"
          offer     = "sles-15-sp2-byos"
          sku       = "gen2"
          admin     = "azureuser"
        },
    UBUNTU       =  {
          publisher = "Canonical"
          offer     = "UbuntuServer"
          sku       = "19_10-daily-gen2"
          admin     = "azureuser"
        }
    


       }
     }  
variable "OS" {
  description = "the selected ami based OS"
  default       = "CENTOS7" 
}

# VNIC INFO
        variable "private_ip" {
        default = "192.168.10.51"
      }
      
# BOOT INFO      
  # user data
variable "user_data" { 
  default = "./cloud-init/centos_userdata.txt"
  }     

 # EBS 
#
variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}
  


# ── outputs.tf ────────────────────────────────────
output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.terra_vnet.name
}
output "vnet_id" {
      description = "id of created VNET. "
      value       = azurerm_virtual_network.terra_vnet.id
    }
output "vnet_CIDR" {
      description = "cidr block of created VNET. "
      value       = azurerm_virtual_network.terra_vnet.address_space
    }    
    
output "Subnet_Name" {
      description = "Name of created VNET's Subnet. "
      value       =  azurerm_subnet.terra_sub.name
    }
output "Subnet_id" {
      description = "id of created VNET. "
      value       = azurerm_subnet.terra_sub.id
    }
output "Subnet_CIDR" {
      description = "cidr block of VNET's Subnet. "
      value       = azurerm_subnet.terra_sub.address_prefixes
    }


output "vnet_dedicated_security_group_Name" {
       description = "Security Group Name. "
       value       = azurerm_network_security_group.terra_nsg.name
   }
output "vnet_dedicated_security_group_id" {
       description = "Security group id. "
       value       = azurerm_network_security_group.terra_nsg.id
   }
output "vnet_dedicated_security_ingress_rules" {
      description = "Shows ingress rules of the Security group "
     value       = azurerm_network_security_group.terra_nsg.security_rule
}           
    
##  INSTANCE OUTPUT

      output "instance_id" {
        description = " id of created instances. "
        value       = azurerm_linux_virtual_machine.terravm.id
      }
      
      output "private_ip" {
        description = "Private IPs of created instances. "
        value       = azurerm_linux_virtual_machine.terravm.private_ip_address
      }
      
      output "public_ip" {
        description = "Public IPs of created instances. "
        value       = azurerm_public_ip.terrapubip.ip_address
      }

 output "SSH_Connection" {
     value      = format("ssh connection to instance  ${var.prefix}-vm ==> sudo ssh -i ~/id_rsa_az centos@%s",azurerm_public_ip.terrapubip.ip_address)
}

  
  
    

# ── compute.tf ────────────────────────────────────

      terraform {
         required_version = ">= 1.0.3"
      }

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.az_location}"
}
resource "azurerm_network_interface" "Terranic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "terra_subconfiguration"
    subnet_id                     = azurerm_subnet.terra_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terrapubip.id
  }
}

  resource "azurerm_public_ip" "terrapubip" {
  name                = "TerraPublicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    app = "Static WebSite Ip "
  }
}

resource "azurerm_network_interface_security_group_association" "terra_assos_pubip_nsg" {
  network_interface_id      = azurerm_network_interface.Terranic.id
  network_security_group_id = azurerm_network_security_group.terra_nsg.id
}
resource "azurerm_linux_virtual_machine" "terravm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.Terranic.id]
  size               = var.vm_size
  computer_name  = "terrahost"
  admin_username = var.os_publisher[var.OS].admin
  disable_password_authentication = true
  provision_vm_agent = true
  custom_data    = base64encode ("${file(var.user_data)}")
        #custom_data    = "${path.root}/scripts/middleware_disk.sh"

admin_ssh_key {
    username = var.os_publisher[var.OS].admin
    public_key = file("~/id_rsa_az.pub")
  }
######################
# IMAGE
######################  
 source_image_reference {
    publisher = var.os_publisher[var.OS].publisher
    offer     = var.os_publisher[var.OS].offer
    sku       = var.os_publisher[var.OS].sku
    version   = "latest"
  }
 
 


  # Uncomment this line to delete the OS disk automatically when deleting the VM
  #delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
  
  

######################
# VOLUME
######################  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.osdisk_size
  }
 
  tags = {
    environment = "demo"
  }
}



    
 

# ── vnet.tf ────────────────────────────────────
 terraform {
      required_version = ">= 1.0.3"
    }
provider "azurerm" {
    features {
          }
    }
#################
# RESOURCE GROUP
#################



#################
# VNET
#################
resource "azurerm_virtual_network" "terra_vnet" {
  name                = "${var.prefix}-network"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = [var.vnet_cidr]
}
#################
# SUBNET
#################
resource "azurerm_subnet" "terra_sub" {
  name                 = "terra_sub"
  virtual_network_name = "${azurerm_virtual_network.terra_vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefixes     = [var.subnet_cidr]
}

######################
# Network Security Group
######################    
resource "azurerm_network_security_group" "terra_nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Egress"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
security_rule {
    name                       = "Inbound HTTP access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["22","80","443","3389"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "RDP-HTTP-HTTPS ingress trafic" 
  }

  
tags = {
    Name = "SSH ,HTTP, and HTTPS"
  }
    timeouts {}
}

resource "azurerm_subnet_network_security_group_association" "nsg_sub" {
  subnet_id                 = azurerm_subnet.terra_sub.id
  network_security_group_id = azurerm_network_security_group.terra_nsg.id
}