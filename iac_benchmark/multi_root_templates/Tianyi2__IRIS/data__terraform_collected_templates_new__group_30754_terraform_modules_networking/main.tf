resource "azurerm_virtual_network" "main" {
  name                = "${var.name_prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# AKS subnet
resource "azurerm_subnet" "aks" {
  name                 = "${var.name_prefix}-aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aks_subnet_cidr]

  service_endpoints = [
    "Microsoft.ContainerRegistry", "Microsoft.KeyVault"
  ]
}

# Database subnet - PostgreSQL delegation no longer relevant
resource "azurerm_subnet" "database" {
  name                 = "${var.name_prefix}-db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.database_subnet_cidr]

  # No delegation needed for SQL Server (uses private endpoints)
}

# Private Endpoint subnet for secure PaaS service connections
resource "azurerm_subnet" "private_endpoints" {
  name                 = "${var.name_prefix}-private-endpoints-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_endpoints_subnet_cidr]

  # Private endpoints require this configuration
  private_endpoint_network_policies             = "Disabled"

  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

# Enhanced NSG for AKS subnet with security-first approach
resource "azurerm_network_security_group" "aks" {
  name                = "${var.name_prefix}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow inbound traffic from Application Gateway subnet (when implemented)
  security_rule {
    name                       = "AllowHTTPFromAppGW"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.app_gateway_subnet_cidr # App Gateway subnet (for future)
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPSFromAppGW"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.app_gateway_subnet_cidr # App Gateway subnet (for future)
    destination_address_prefix = "*"
  }

  # Temporary: Allow direct HTTP/HTTPS for testing (remove when App Gateway implemented)
  security_rule {
    name                       = "AllowHTTPDirectTemp"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPSDirectTemp"
    priority                   = 1101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow outbound to database subnet for SQL Server
  security_rule {
    name                       = "AllowToDatabase"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "*"
    destination_address_prefix = var.database_subnet_cidr
  }

  # Allow outbound to private endpoints (Key Vault, etc.)
  security_rule {
    name                       = "AllowToPrivateEndpoints"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = var.private_endpoints_subnet_cidr
  }

  tags = var.tags
}

# Enhanced NSG for database subnet - deny by default, explicit allows
resource "azurerm_network_security_group" "database" {
  name                = "${var.name_prefix}-db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow SQL Server access only from AKS subnet (via private endpoints)
  security_rule {
    name                       = "AllowSQLServerFromAKS"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = var.aks_subnet_cidr # AKS subnet only
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic (explicit deny)
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# NSG for private endpoints subnet
resource "azurerm_network_security_group" "private_endpoints" {
  name                = "${var.name_prefix}-private-endpoints-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTPS from AKS subnet for Key Vault access
  security_rule {
    name                       = "AllowHTTPSFromAKS"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.aks_subnet_cidr # AKS subnet only
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}
