locals {
  tags = {
    vendor      = "cosmotech"
    stage       = var.project_stage
    customer    = var.customer_name
    project     = var.project_name
    cost_center = var.cost_center
  }
}

resource "azurerm_container_registry" "acr" {
  name                          = var.container_name
  resource_group_name           = var.resource_group
  location                      = var.location
  sku                           = "Standard"
  admin_enabled                 = var.admin_enabled
  quarantine_policy_enabled     = var.quarantine_policy_enabled
  trust_policy_enabled          = var.trust_policy
  data_endpoint_enabled         = var.data_endpoint_enabled
  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option    = "AzureServices"
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  tags                          = local.tags
}

resource "azurerm_role_assignment" "acr_contributor" {
  count                = var.deployment_type != "ARM" ? 1 : 0
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Contributor"
  principal_id         = var.tenant_sp_object_id
}