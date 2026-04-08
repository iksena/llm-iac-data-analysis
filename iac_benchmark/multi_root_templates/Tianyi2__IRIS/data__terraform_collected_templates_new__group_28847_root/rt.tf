resource "azurerm_route_table" "this" {
  name                          = var.rt_name
  location                      = data.azurerm_resource_group.this.location
  resource_group_name           = data.azurerm_resource_group.this.name
  disable_bgp_route_propagation = var.rt_disable_bgp
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = azurerm_subnet.this.id
  route_table_id = azurerm_route_table.this.id
}
