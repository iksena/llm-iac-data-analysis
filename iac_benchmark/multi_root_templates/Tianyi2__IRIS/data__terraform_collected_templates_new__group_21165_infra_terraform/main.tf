#########################################
# main.tf
#########################################

terraform {
  required_version = ">= 1.11.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27.0"
    }
  }
}

#############################
# Providers Configuration
#############################

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

#############################
# Networking & IAM Setup
#############################

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-kubevirt-demo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group.rg]
}

# AKS Subnet
resource "azurerm_subnet" "aks" {
  name                 = "subnet-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_resource_group.rg]
}

# NSG for AKS Subnet
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "nsg-aks-subnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group.rg]
}

# Outbound Internet (always allowed)
resource "azurerm_network_security_rule" "allow_outbound" {
  name                        = "AllowOutboundInternet"
  priority                    = 300
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
  depends_on                  = [azurerm_resource_group.rg]
}

# Inbound HTTP from your developers (0.0.0.0/0)
resource "azurerm_network_security_rule" "allow_inbound_http" {
  name                        = "AllowInboundHttpFromTrusted"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = concat(var.developer_api_ips, var.developer_vpn_ips)
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
  depends_on                  = [azurerm_resource_group.rg]
}

# Inbound HTTPS from your developers (0.0.0.0/0)
resource "azurerm_network_security_rule" "allow_inbound_https" {
  name                        = "AllowInboundHttpsFromTrusted"
  priority                    = 210
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = concat(var.developer_api_ips, var.developer_vpn_ips)
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
  depends_on                  = [azurerm_resource_group.rg]
}

# ─────────── NEW RULES ───────────

# 1) Allow Azure Load Balancer health probes on 80 & 443
resource "azurerm_network_security_rule" "allow_lb_probes_http_https" {
  name                        = "AllowAzureLBProbes"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_port_ranges     = ["80", "443"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
  depends_on                  = [azurerm_resource_group.rg]
}

# 2) Allow Azure Load Balancer to probe Kubernetes NodePorts
resource "azurerm_network_security_rule" "allow_lb_probes_nodeport" {
  name                        = "AllowAzureLBNodePorts"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_port_range      = "30000-32767"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
  depends_on                  = [azurerm_resource_group.rg]
}

# Associate NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "aks_nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
  depends_on                = [azurerm_resource_group.rg]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name                          = "default"
    vm_size                       = var.aks_default_node_pool_vm_size
    temporary_name_for_rotation   = "tempnodepool"
    auto_scaling_enabled          = true
    min_count                     = var.aks_default_node_pool_min_count
    max_count                     = var.aks_default_node_pool_max_count
    vnet_subnet_id                = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = "10.2.0.0/16"
    dns_service_ip     = "10.2.0.10"
  }
  depends_on = [azurerm_resource_group.rg]
}

# Assign AKS identity rights
resource "azurerm_role_assignment" "aks_subnet_role" {
  scope                = azurerm_subnet.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  depends_on           = [azurerm_resource_group.rg]
}

resource "azurerm_role_assignment" "aks_routetable_role" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  depends_on           = [azurerm_resource_group.rg]
}
