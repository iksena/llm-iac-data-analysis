provider "azurerm" {
  features {}
}

module "resource_group" {
  source      = "cypik/resource-group/azure"
  version     = "1.0.2"
  name        = "app"
  environment = "test"
  location    = "North Europe"
}

##-----------------------------------------------------------------------------
## Virtual Network module call.
##-----------------------------------------------------------------------------
module "vnet" {
  source                 = "cypik/vnet/azure"
  version                = "1.0.2"
  name                   = "app"
  environment            = "test"
  resource_group_name    = module.resource_group.resource_group_name
  location               = module.resource_group.resource_group_location
  address_space          = "10.0.0.0/16"
  enable_ddos_pp         = false
  enable_network_watcher = false
}

module "subnet" {
  source               = "cypik/subnet/azure"
  version              = "1.0.2"
  name                 = "app"
  environment          = "test"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet[*].name)

  #subnet
  subnet_names    = ["subnet1"]
  subnet_prefixes = ["10.0.1.0/24"]

  # route_table
  enable_route_table = true
  route_table_name   = "default_subnet"
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}


##-----------------------------------------------------------------------------
## Network Security Group module call.
##-----------------------------------------------------------------------------
module "network_security_group" {
  source                  = "./../"
  name                    = "app"
  environment             = "test"
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  subnet_ids              = [module.subnet.default_subnet_id]
  inbound_rules = [
    {
      name                       = "ssh"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "10.20.0.0/32"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    },
    {
      name                       = "https"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "80"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "80"
      description                = "ssh allowed port"
    }
  ]
}