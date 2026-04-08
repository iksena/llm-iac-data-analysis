# Security module for Azure Enterprise Learning
# Implements Key Vault, managed identities, and private endpoints

# Current user for Key Vault access policy
data "azurerm_client_config" "current" {}

# Generate consistent naming suffix
locals {
  kv_name = "${var.name_prefix}-kv-${substr(md5("${var.resource_group_name}-${var.location}"), 0, 4)}"
}

# User-assigned managed identity for AKS workload identity
resource "azurerm_user_assigned_identity" "aks_workload" {
  name                = "${var.name_prefix}-workload-identity"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Azure Key Vault with security-first configuration
resource "azurerm_key_vault" "main" {
  name                = local.kv_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Security configuration
  enable_rbac_authorization       = true
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = false
  enabled_for_template_deployment = false
  
  # Network security - configurable for different environments
  public_network_access_enabled = var.allow_public_access
  
  # Network ACLs - secure by default with environment-specific overrides
  network_acls {
    default_action = var.allow_public_access ? "Allow" : "Deny"
    bypass         = "AzureServices"
    
    # Allow specific IP ranges if configured
    ip_rules = var.allowed_ip_ranges
    
    # Allow VNet subnets if configured
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }
  
  # Soft delete protection (security best practice)
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.enable_purge_protection

  tags = var.tags
}

# Private endpoint for Key Vault
resource "azurerm_private_endpoint" "key_vault" {
  name                = "${var.name_prefix}-kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-kv-psc"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  tags = var.tags
}

# Private DNS zone for Key Vault
resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link private DNS zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "${var.name_prefix}-kv-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  tags = var.tags
}

# RBAC assignments for Key Vault

# Current user (for Terraform management and initial setup)
resource "azurerm_role_assignment" "kv_admin_current_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# AKS workload identity for application access
resource "azurerm_role_assignment" "kv_secrets_user_aks" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks_workload.principal_id
}

# Sample secrets for application configuration
resource "azurerm_key_vault_secret" "database_connection_string" {
  name         = "database-connection-string"
  value        = "Server=tcp:${var.database_fqdn},1433;Initial Catalog=appdb;User ID=placeholder;Password=placeholder;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.kv_admin_current_user]

  tags = var.tags

  lifecycle {
    ignore_changes = [value] # Allow manual updates without Terraform overwriting
  }
}

resource "azurerm_key_vault_secret" "api_key_example" {
  name         = "api-key-example"
  value        = "example-api-key-${random_string.api_key.result}"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.kv_admin_current_user]

  tags = var.tags
}

resource "random_string" "api_key" {
  length  = 32
  special = true
}
