# Create the resource group for dev environment
resource "azurerm_resource_group" "main" {
  name     = "${var.name_prefix}-rg"
  location = var.location

  tags = var.tags
}

# Use our networking module
module "networking" {
  source = "../../modules/networking"
  
  name_prefix         = var.name_prefix
  location           = var.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_address_space = var.vnet_address_space
  aks_subnet_cidr    = var.aks_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
  private_endpoints_subnet_cidr = var.private_endpoints_subnet_cidr
  app_gateway_subnet_cidr       = var.app_gateway_subnet_cidr
  
  tags = var.tags
}

# Grant AKS cluster access to shared ACR (enterprise pattern)
# Uses remote state reference instead of data block
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = module.aks.kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                           = local.shared_acr_id
  skip_service_principal_aad_check = true
}

# Use our AKS module
module "aks" {
  source = "../../modules/aks"
  
  name_prefix         = var.name_prefix
  location           = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id          = module.networking.aks_subnet_id
  kubernetes_version = var.kubernetes_version
  enable_monitoring  = var.enable_monitoring
  
  # Enterprise pattern: No personal accounts in infrastructure
  # Cloud engineers access via Azure AD groups (managed outside Terraform)
  # Service principal gets automatic admin access for automation
  
  tags = var.tags
}

# Security module - Key Vault with managed identity
module "security" {
  source = "../../modules/security"
  
  name_prefix                   = var.name_prefix
  location                     = var.location
  resource_group_name          = azurerm_resource_group.main.name
  vnet_id                      = module.networking.vnet_id
  private_endpoints_subnet_id  = module.networking.private_endpoints_subnet_id
  database_fqdn                = module.database.server_fqdn
  
  # Development environment security configuration
  allow_public_access          = true   # Allow for easier development access
  enable_purge_protection      = false  # Allow cleanup for cost savings
  soft_delete_retention_days   = 7      # Minimum retention for dev
  
  # Allow access from AKS subnet
  allowed_subnet_ids = [
    module.networking.aks_subnet_id
  ]
  
  tags = var.tags
}

# Database module - Azure SQL Database with private endpoint
module "database" {
  source = "../../modules/database"
  
  name_prefix                 = var.name_prefix
  location                   = var.location
  resource_group_name        = azurerm_resource_group.main.name
  vnet_id                    = module.networking.vnet_id
  private_endpoints_subnet_id = module.networking.private_endpoints_subnet_id
  admin_principal_name       = var.database_admin_principal
  
  tags = var.tags
}

# Learning environment: Grant direct AKS admin access to current user
# Enterprise pattern: Would use Azure AD groups instead of individual users
resource "azurerm_role_assignment" "aks_admin_learning_user" {
  principal_id         = var.aks_admin_principal_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  scope               = module.aks.cluster_id
}
