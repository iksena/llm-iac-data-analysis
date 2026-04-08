resource "azurerm_kubernetes_cluster" "example" {

  # AKS cluster basic information
  name                = "${local.prefix}-k8s"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "${local.prefix}-k8s"

 # node pool settings 
  default_node_pool {
    name       = "default"
    node_count = 2
    min_count = 1
    max_count = 10
    vm_size    = "Standard_DS2_v2"
    enable_auto_scaling = true
  }

  # AKS use system auto created identity 
  identity {
    type = "SystemAssigned"
  }
}