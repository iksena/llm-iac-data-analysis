
/* 
  virtual network
*/ 

resource "azurerm_virtual_network" "VirtualNetwork" {

  /* 
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
  */ 

  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  name                = var.virtual_network_name
  address_space       = [var.virtual_network_address_prefix]
  dns_servers         = [var.dns_primary_server_ip_address]

  tags = {

    backup      = var.tag_backup
    environment = var.tag_environment
    id          = var.tag_id
    owner       = var.tag_owner
    workload    = var.tag_workload

  }
  
}



/* 
  subnet
*/ 

resource "azurerm_subnet" "Subnet" {

  /*
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
  */ 

  resource_group_name  = var.resource_group_name

  depends_on = [azurerm_virtual_network.VirtualNetwork]

  virtual_network_name = var.virtual_network_name

  for_each = var.subnets
  
  name                 = each.value.subnet_name
  address_prefixes     = [each.value.subnet_address_prefix]

}



/*
  route table
*/ 

resource "azurerm_route_table" "RouteTable" {

  /*
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table
  */ 

  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  
  depends_on = [azurerm_subnet.Subnet]

  for_each = var.subnets

  name  = each.value.route_table_name

  tags = {

    backup      = var.tag_backup
    environment = var.tag_environment
    id          = var.tag_id
    owner       = var.tag_owner
    workload    = var.tag_workload
    
  }

}



/*
  route table association
*/ 

resource "azurerm_subnet_route_table_association" "SubnetRouteTableAssociation" {

  /* 
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association
  */ 

  depends_on = [azurerm_route_table.RouteTable]

  for_each = var.subnets

  subnet_id      = azurerm_subnet.Subnet[each.key].id
  route_table_id = azurerm_route_table.RouteTable[each.key].id

}

resource "azurerm_route" "DefaultRoute" {

  /* 
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route
  */ 

  depends_on = [azurerm_route_table.RouteTable]

  resource_group_name = var.resource_group_name

  for_each = var.subnets

  route_table_name = each.value.route_table_name

  name                   = "DefaultRoute"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.gateway_ip_address

}

resource "azurerm_route" "RouteToVNET" {

  /* 
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route
  */ 
  
  depends_on = [azurerm_route_table.RouteTable]

  resource_group_name = var.resource_group_name

  for_each = var.subnets

  route_table_name = each.value.route_table_name

  name                   = "RouteToVNET"
  address_prefix         = var.virtual_network_address_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.gateway_ip_address

}

resource "azurerm_route" "RouteToSubnet" {

  /* 
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route
  */ 
  
  depends_on = [azurerm_route_table.RouteTable]

  resource_group_name = var.resource_group_name

  for_each = var.subnets

  route_table_name = each.value.route_table_name

  name                   = "RouteToSubnet"
  address_prefix         = each.value.subnet_address_prefix
  next_hop_type          = "VnetLocal"

}



/*
  network security group
*/ 

resource "azurerm_network_security_group" "SubnetNetworkSecurityGroup" {

  /*
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
  */ 
  
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  depends_on = [azurerm_subnet.Subnet]

  for_each = var.subnets

  name                = each.value.network_security_group_name

  tags = {

    backup      = var.tag_backup
    environment = var.tag_environment
    id          = var.tag_id
    owner       = var.tag_owner
    workload    = var.tag_workload

  }

}



/* 
  security rules
*/ 

resource "azurerm_network_security_rule" "NetworkSecurityRuleRFC1918" {

  /* 
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
  */
  resource_group_name            = var.resource_group_name

  depends_on = [azurerm_network_security_group.SubnetNetworkSecurityGroup]

  for_each = var.subnets

  network_security_group_name    = each.value.network_security_group_name

  name                           = "Any_RFC1918_InBound"
  priority                       = "105"
  direction                      = "Inbound"
  access                         = "Allow"
  protocol                       = "*"
  source_address_prefixes        = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
  source_port_range              = "*"
  destination_address_prefixes   = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
  destination_port_range         = "*"
  
}



/* 
  network security groups association
*/ 

resource "azurerm_subnet_network_security_group_association" "SubnetNetworkSecurityGroupAssociation" {

  /*
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association 
  */ 
  
  for_each = var.subnets

  subnet_id = azurerm_subnet.Subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.SubnetNetworkSecurityGroup[each.key].id

}
