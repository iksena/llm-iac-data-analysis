
resource "azurerm_automation_account" "AutomationAccount" {

  /* 
    references
    - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account
  */ 

  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location

  name                  = var.automation_account_name
  sku_name              = "Basic"

  identity {

    type = "SystemAssigned"

  }

  tags = {

    backup      = var.tag_backup
    environment = var.tag_environment
    id          = var.tag_id
    owner       = var.tag_owner
    workload    = var.tag_workload

  }

}
