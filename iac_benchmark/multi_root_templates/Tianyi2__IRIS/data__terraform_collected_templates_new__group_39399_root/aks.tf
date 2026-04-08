module "aks" {
  source = "./modules/aks"
  count  = var.create_aks ? 1 : 0

  admin_username                       = var.admin_username
  agents_availability_zones            = var.agents_availability_zones
  agents_count                         = var.agents_count
  agents_labels                        = local.agents_labels
  agents_max_count                     = var.agents_max_count
  agents_max_pods                      = var.agents_max_pods
  agents_min_count                     = var.agents_min_count
  agents_pool_name                     = var.agents_pool_name
  agents_size                          = var.agents_size
  agents_tags                          = local.agents_tags
  agents_type                          = var.agents_type
  client_id                            = var.client_id
  client_secret                        = var.client_secret
  cluster_log_analytics_workspace_name = var.cluster_log_analytics_workspace_name
  cluster_name                         = var.aks_cluster_name
  enable_auto_scaling                  = var.enable_auto_scaling
  enable_azure_policy                  = var.enable_azure_policy
  enable_http_application_routing      = var.enable_http_application_routing
  enable_kube_dashboard                = var.enable_kube_dashboard
  enable_log_analytics_workspace       = var.enable_log_analytics_workspace
  enable_node_public_ip                = var.enable_node_public_ip
  enable_role_based_access_control     = var.enable_role_based_access_control
  identity_type                        = var.identity_type
  kubernetes_version                   = var.kubernetes_version
  log_analytics_workspace_sku          = var.log_analytics_workspace_sku
  log_retention_in_days                = var.log_retention_in_days
  net_profile_dns_service_ip           = var.net_profile_dns_service_ip
  net_profile_docker_bridge_cidr       = var.net_profile_docker_bridge_cidr
  net_profile_outbound_type            = var.net_profile_outbound_type
  net_profile_pod_cidr                 = var.net_profile_pod_cidr
  net_profile_service_cidr             = var.net_profile_service_cidr
  network_plugin                       = var.network_plugin
  network_policy                       = var.network_policy
  orchestrator_version                 = var.orchestrator_version
  os_disk_size_gb                      = var.os_disk_size_gb
  prefix                               = var.prefix
  private_cluster_enabled              = var.private_cluster_enabled
  public_ssh_key                       = local.public_ssh_key
  rbac_aad_admin_group_object_ids      = var.rbac_aad_admin_group_object_ids
  rbac_aad_client_app_id               = var.rbac_aad_client_app_id
  rbac_aad_managed                     = var.rbac_aad_managed
  rbac_aad_server_app_id               = var.rbac_aad_server_app_id
  rbac_aad_server_app_secret           = var.rbac_aad_server_app_secret
  resource_group_name                  = var.resource_group_name
  sku_tier                             = var.sku_tier
  tags                                 = var.tags
  user_assigned_identity_id            = var.user_assigned_identity_id
  vnet_subnet_id                       = var.vnet_subnet_id
}

# Get cluster location.
data "azurerm_kubernetes_cluster" "cluster" {
  depends_on = [module.aks]
  count               = var.create_aks || var.create_ocean ? 1 : 0
  resource_group_name = var.resource_group_name
  name                = local.aks_cluster_name
}

# Get the ID of the node resource group (MC_xxx).
data "azurerm_resource_group" "node_resource_group" {
  count = var.create_aks || var.create_ocean ? 1 : 0
  name  = local.node_resource_group_name
}

# Allow the Kubelet identity to manage AKS resources in node resource group (MC_xxx).
resource "azurerm_role_assignment" "kubelet_contributor" {
  count = (
    (var.create_aks || var.create_ocean) &&
    (var.client_id == "" || var.client_secret == "") &&
    (var.kubelet_assign_role != "" && var.kubelet_assign_role != null)
  ) ? 1 : 0

  scope                = data.azurerm_resource_group.node_resource_group[0].id
  principal_id         = local.kubelet_identity_object_id
  role_definition_name = var.kubelet_assign_role
}
