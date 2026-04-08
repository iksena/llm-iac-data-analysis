# Get current client configuration
data "azurerm_client_config" "current" {}

# Create the resource group for shared resources
resource "azurerm_resource_group" "shared" {
  name     = "${var.name_prefix}-rg"
  location = var.location

  tags = var.tags
}

# Azure Container Registry (shared across all environments)
# Enterprise pattern: Single shared ACR with environment tag promotion
resource "azurerm_container_registry" "shared" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.shared.name
  location            = azurerm_resource_group.shared.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled

  # Cost optimization: Basic tier for learning environment
  # Shared across dev/staging/prod with environment tag promotion
  
  tags = merge(var.tags, {
    Service     = "container-registry"
    SharedBy    = "all-environments"
  })
}

# GitHub Actions Service Principal information
# Enterprise pattern: Store service principal details as variables
# In production, these would come from Key Vault or secure parameter store
locals {
  github_actions = {
    client_id       = var.github_actions_client_id
    object_id       = var.github_actions_object_id  
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
  }
}
