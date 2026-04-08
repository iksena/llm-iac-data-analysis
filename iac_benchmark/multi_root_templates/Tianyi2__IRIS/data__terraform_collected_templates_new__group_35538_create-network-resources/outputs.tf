locals {
  subscription = "/subscriptions/${var.subscription_id}"
  rg_name      = "resourceGroups/${var.tenant_resource_group}"
  vnet_name    = "${azurerm_virtual_network.tenant_vnet.name}/subnets/${var.subnet_name}"
}

output "out_vnet" {
  value = azurerm_virtual_network.tenant_vnet.name
}

output "out_subnet_name" {
  value = var.subnet_name
}

output "out_subnet_id" {
  value = "${local.subscription}/${local.rg_name}/providers/Microsoft.Network/virtualNetworks/${local.vnet_name}"
}

output "out_blob_private_dns_zone_id" {
  value = data.azurerm_private_dns_zone.platform_vnetlink.id
}