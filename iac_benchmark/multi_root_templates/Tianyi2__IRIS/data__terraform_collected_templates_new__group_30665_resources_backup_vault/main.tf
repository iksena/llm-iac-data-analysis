
resource "azurerm_data_protection_backup_vault" "BackupVault" {
  
    /*
        references
        - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_protection_backup_vault
    */

    resource_group_name = var.resource_group_name
    location            = var.resource_group_location
  
    name    = var.backup_vault_name

    datastore_type  = "OperationalStore"
    redundancy      = "LocallyRedundant"

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
