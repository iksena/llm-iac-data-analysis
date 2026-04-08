locals {
  tags = {
    vendor      = "cosmotech"
    stage       = var.project_stage
    customer    = var.customer_name
    project     = var.project_name
    cost_center = var.cost_center
  }
}

resource "azurerm_virtual_network" "tenant_vnet" {
  name                = "Cosmotech-${var.tenant_resource_group}-VNet"
  location            = var.location
  resource_group_name = var.tenant_resource_group
  address_space       = [var.tenant_virtual_network_address_prefix]

  subnet {
    name              = var.subnet_name
    address_prefixes  = [var.tenant_virtual_subnet_network_address_prefix]
    service_endpoints = ["Microsoft.Storage"]
  }
  tags = local.tags
}

resource "azurerm_virtual_network_peering" "vnet_tenant_to_platform" {
  name                      = "peer${var.tenant_resource_group}vnet1"
  resource_group_name       = var.tenant_resource_group
  virtual_network_name      = azurerm_virtual_network.tenant_vnet.name
  remote_virtual_network_id = var.platform_vnet.id
}

resource "azurerm_virtual_network_peering" "vnet_platform_to_tenant" {
  name                      = "peer${var.tenant_resource_group}vnet2"
  resource_group_name       = var.vnet_resource_group
  virtual_network_name      = var.platform_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.tenant_vnet.id
}

resource "azurerm_role_assignment" "vnet_network_contributor" {
  scope                = azurerm_virtual_network.tenant_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = var.networkadt_sp_object_id
}

data "azurerm_private_dns_zone" "platform_vnetlink" {
  name                = var.blob_privatedns_zonename
  resource_group_name = var.kubernetes_resource_group
}
resource "azurerm_private_dns_zone_virtual_network_link" "private_link" {
  name                  = "${var.tenant_resource_group}-vnet-link"
  resource_group_name   = var.kubernetes_resource_group
  private_dns_zone_name = data.azurerm_private_dns_zone.platform_vnetlink.name
  virtual_network_id    = azurerm_virtual_network.tenant_vnet.id
}
