
resource "azurerm_recovery_services_vault" "RecoveryServicesVault" {

    /*
        references
        - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault
    */ 

    resource_group_name     = var.resource_group_name
    location                = var.resource_group_location
  
    name                    = var.recovery_services_vault_name

    sku                             = "Standard"
    soft_delete_enabled             = true
    storage_mode_type               = "ZoneRedundant"
    cross_region_restore_enabled    = false

    tags = {

        backup      = var.tag_backup
        environment = var.tag_environment
        id          = var.tag_id
        owner       = var.tag_owner
        workload    = var.tag_workload

    }

}
