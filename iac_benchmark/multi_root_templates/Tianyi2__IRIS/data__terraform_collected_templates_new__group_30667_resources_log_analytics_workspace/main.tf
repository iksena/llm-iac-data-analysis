
resource "azurerm_log_analytics_workspace" "LogAnalyticsWorkspace" {

  /*
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace 
  */

  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  name                = var.log_analytics_workspace_name

  sku                 = "PerGB2018"
  retention_in_days   = 365

  tags = {

    backup      = var.tag_backup
    environment = var.tag_environment
    id          = var.tag_id
    owner       = var.tag_owner
    workload    = var.tag_workload

  }

}
