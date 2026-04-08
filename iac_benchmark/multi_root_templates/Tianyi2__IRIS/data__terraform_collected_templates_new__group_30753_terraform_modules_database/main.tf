# Azure SQL Database with enterprise security configuration

# Current Azure client configuration
data "azurerm_client_config" "current" {}

# Random password for SQL admin (stored in Key Vault)
resource "random_password" "sql_admin" {
  length  = 32
  special = true
}

# Azure SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = "${var.name_prefix}-sqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = random_password.sql_admin.result

  # Enable Azure AD authentication
  azuread_administrator {
    login_username = var.admin_principal_name
    object_id      = data.azurerm_client_config.current.object_id
    tenant_id      = data.azurerm_client_config.current.tenant_id
  }

  # Security settings
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"

  tags = var.tags
}

# Azure SQL Database - Serverless (Free Tier)
resource "azurerm_mssql_database" "main" {
  name           = "appdb"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 32 # Free tier includes 32GB
  sku_name       = "GP_S_Gen5_1" # General Purpose Serverless, 1 vCore
  zone_redundant = false

  # Serverless configuration for auto-pause (cost optimization)
  auto_pause_delay_in_minutes = 60  # Auto-pause after 1 hour of inactivity
  min_capacity                = 0.5 # Minimum vCores when active

  # Backup settings
  short_term_retention_policy {
    retention_days = 7
  }

  tags = var.tags
}

# Private DNS zone for SQL Server
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link private DNS zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${var.name_prefix}-sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  tags = var.tags
}

# Private endpoint for SQL Server
resource "azurerm_private_endpoint" "sql" {
  name                = "${var.name_prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }

  tags = var.tags
}

# SQL Server auditing for security compliance
resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  server_id              = azurerm_mssql_server.main.id
  enabled                = true
  retention_in_days      = 90
  log_monitoring_enabled = true
}

# Transparent Data Encryption is automatically enabled for SQL Database
