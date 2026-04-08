provider "azurerm" {
  features {}
}

provider "spotinst" {
  token   = var.spotinst_token
  account = var.spotinst_account
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

data "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

module "ocean-aks" {
  source     = "../../"
  depends_on = [data.azurerm_kubernetes_cluster.this]

  # Credentials.
  spotinst_token   = var.spotinst_token
  spotinst_account = var.spotinst_account

  # Conditions.
  create_aks = false

  # Configuration.
  resource_group_name = var.resource_group_name
  aks_cluster_name    = var.aks_cluster_name
  node_pools          = var.node_pools

  # Optional configuration to be applied to each node pool during
  # the creation of its corresponding Ocean Virtual Node Group.
  node_pools_labels    = var.node_pools_labels
  node_pools_taints    = var.node_pools_taints
  node_pools_tags      = var.node_pools_tags
  node_pools_headrooms = var.node_pools_headrooms
}
