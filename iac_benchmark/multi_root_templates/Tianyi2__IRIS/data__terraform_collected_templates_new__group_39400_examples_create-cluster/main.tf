provider "azurerm" {
  features {}
}

provider "spotinst" {
  token   = var.spotinst_token
  account = var.spotinst_account
}

provider "kubernetes" {
  host                   = module.ocean-aks.host
  client_certificate     = base64decode(module.ocean-aks.client_certificate)
  client_key             = base64decode(module.ocean-aks.client_key)
  cluster_ca_certificate = base64decode(module.ocean-aks.cluster_ca_certificate)
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "ocean-aks" {
  source     = "../../"
  depends_on = [azurerm_resource_group.this]

  # Credentials.
  spotinst_token   = var.spotinst_token
  spotinst_account = var.spotinst_account

  # Configuration.
  resource_group_name            = var.resource_group_name
  prefix                         = var.prefix
  enable_log_analytics_workspace = false
}
