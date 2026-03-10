# ── variables.tf ────────────────────────────────────
# Azure account region and authentication 
variable "prefix" {
  description = "The prefix used for all resources in this example"
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
    # formatlist("%s:  %s" ,azurerm_network_security_group.terra_sg.ingress[*].description,formatlist("%s , CIDR: %s", azurerm_network_security_group.terra_sg.ingress[*].to_port,azurerm_network_security_group.terra_sg.ingress[*].cidr_blocks[0]))


  






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

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = "${var.az_location}"
}

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
# aws_subnet.terra_sub:
resource "azurerm_subnet" "terra_sub" {
  name                 = "internal"
  virtual_network_name = "${azurerm_virtual_network.terra_vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefixes     = [var.subnet_cidr]
}

######################
# Network Security Group
######################    
# aws_security_group.terra_sg:
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
    name                       = "Inbound_HTTP_access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_ranges          = ["22","80","443","3389"]
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
