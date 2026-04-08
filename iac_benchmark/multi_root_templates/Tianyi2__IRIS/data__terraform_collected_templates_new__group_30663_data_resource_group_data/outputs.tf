
output "resource_group_id" {

  value     = data.azurerm_resource_group.ResourceGroup.id

}

output "resource_group_location" {

  value     = data.azurerm_resource_group.ResourceGroup.location

}

output "resource_group_name" {

  value     = data.azurerm_resource_group.ResourceGroup.name

}
