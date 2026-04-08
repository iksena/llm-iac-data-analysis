# Creation of subnets for the database
resource "azurerm_subnet" "database_subnet_primary" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.rg_primary.name
  virtual_network_name = azurerm_virtual_network.vnet_primary.name
  address_prefixes     = ["10.0.16.0/21"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }

  service_endpoints = ["Microsoft.Storage"]
  depends_on = [azurerm_virtual_network.vnet_primary, azurerm_virtual_network.vnet_secondary]
}

resource "azurerm_subnet" "database_subnet_secondary" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.rg_secondary.name
  virtual_network_name = azurerm_virtual_network.vnet_secondary.name
  address_prefixes     = ["10.1.16.0/21"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }

  service_endpoints = ["Microsoft.Storage"]
  depends_on = [azurerm_virtual_network.vnet_primary, azurerm_virtual_network.vnet_secondary]
}

resource "azurerm_network_security_group" "psqldbnsg_primary" {
  name                = "db-nsg"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.rg_primary.name

  depends_on = [azurerm_resource_group.rg_primary]
}

resource "azurerm_network_security_group" "psqldbnsg_secondary" {
  name                = "db-nsg"
  location            = var.secondary_location
  resource_group_name = azurerm_resource_group.rg_secondary.name

  depends_on = [azurerm_resource_group.rg_secondary]
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_primary" {
  subnet_id                 = azurerm_subnet.database_subnet_primary.id
  network_security_group_id = azurerm_network_security_group.psqldbnsg_primary.id

  depends_on = [
    azurerm_subnet.database_subnet_primary, 
    azurerm_network_security_group.psqldbnsg_primary
    ]

}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_secondary" {
  subnet_id                 = azurerm_subnet.database_subnet_secondary.id
  network_security_group_id = azurerm_network_security_group.psqldbnsg_secondary.id
  
  depends_on = [
    azurerm_subnet.database_subnet_secondary, 
    azurerm_network_security_group.psqldbnsg_secondary
    ]

}

# Private DNS zone for Database and network links
resource "azurerm_private_dns_zone" "psql_private_dns_zone" {
  name                = "psql-private-dns-zone.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg_primary.name

  depends_on = [
    azurerm_resource_group.rg_primary
  ]

  tags = var.tags
}

# Database servers
resource "azurerm_postgresql_flexible_server" "psqlfs_primary" {
  name                = "${var.project_prefix}-psql-primary-${var.environment}"
  resource_group_name = azurerm_resource_group.rg_primary.name
  location            = var.primary_location
  administrator_login = var.db_admin_login
  administrator_password = var.db_admin_password
  sku_name            = var.db.sku
  version             = var.db.version
  zone = "3"
  private_dns_zone_id    = azurerm_private_dns_zone.psql_private_dns_zone.id
  delegated_subnet_id = azurerm_subnet.database_subnet_primary.id
  public_network_access_enabled = false
  storage_mb = var.db.storage_size

  backup_retention_days = 7

  # # For production environment, uncomment this block
  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [
    azurerm_subnet.database_subnet_primary,
    azurerm_private_dns_zone.psql_private_dns_zone,
    azurerm_virtual_network_peering.vnet_peering_secondary_to_primary,
    azurerm_virtual_network_peering.vnet_peering_primary_to_secondary
  ]

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "psqlfs_database" {
  name      = "${var.db.name}"
  server_id = azurerm_postgresql_flexible_server.psqlfs_primary.id
  collation = "en_US.utf8"
  charset   = "utf8"
  depends_on = [
    azurerm_postgresql_flexible_server.psqlfs_primary
  ]
}

resource "azurerm_postgresql_flexible_server" "psqlfs_secondary" {
  name                = "${var.project_prefix}-psql-secondary-${var.environment}"
  resource_group_name = azurerm_resource_group.rg_secondary.name
  location            = var.secondary_location
  create_mode         = "Replica"
  source_server_id    = azurerm_postgresql_flexible_server.psqlfs_primary.id
  delegated_subnet_id = azurerm_subnet.database_subnet_secondary.id
  private_dns_zone_id    = azurerm_private_dns_zone.psql_private_dns_zone.id
  public_network_access_enabled = false
  storage_mb = var.db.storage_size

  # # For production environment, uncomment this block
  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [
    azurerm_subnet.database_subnet_secondary,
    azurerm_postgresql_flexible_server.psqlfs_primary,
    azurerm_private_dns_zone.psql_private_dns_zone,
    azurerm_virtual_network_peering.vnet_peering_secondary_to_primary,
    azurerm_virtual_network_peering.vnet_peering_primary_to_secondary,
    azurerm_private_dns_zone_virtual_network_link.psql_private_dns_zone_nlink_primary,
    azurerm_private_dns_zone_virtual_network_link.psql_private_dns_zone_nlink_secondary
    ]

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "psql_private_dns_zone_nlink_primary" {
  name                  = "psql-private-dns-nlink-primary-${var.environment}"
  resource_group_name   = azurerm_resource_group.rg_primary.name
  private_dns_zone_name = azurerm_private_dns_zone.psql_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet_primary.id
  
  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "psql_private_dns_zone_nlink_secondary" {
  name                  = "psql-private-dns-nlink-secondary-${var.environment}"
  resource_group_name   = azurerm_resource_group.rg_primary.name
  private_dns_zone_name = azurerm_private_dns_zone.psql_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet_secondary.id
  
  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_virtual_endpoint" "psqlfs_ve" {
  name              = "psql-virtual-endpoint"
  source_server_id  = azurerm_postgresql_flexible_server.psqlfs_primary.id
  replica_server_id = azurerm_postgresql_flexible_server.psqlfs_secondary.id
  type              = "ReadWrite"

  depends_on = [
    azurerm_postgresql_flexible_server.psqlfs_primary,
    azurerm_postgresql_flexible_server.psqlfs_secondary
  ]
}