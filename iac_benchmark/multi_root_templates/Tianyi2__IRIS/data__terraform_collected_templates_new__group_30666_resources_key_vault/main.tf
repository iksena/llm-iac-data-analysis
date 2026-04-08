
resource "azurerm_key_vault" "KeyVault" {

    /* 
      references
      - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault
    */ 

    resource_group_name         = var.resource_group_name
    location                    = var.resource_group_location

    tenant_id                   = var.tenant_id

    name                        = var.keyvault_name
    sku_name                    = "standard"
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false

    access_policy {

      tenant_id   = var.tenant_id
      object_id   = var.object_id

      secret_permissions = [

        "Delete","Get","List","Set"
      
      ]

    }

  tags = {

    backup      = var.tag_backup
    environment = var.tag_environment
    id          = var.tag_id
    owner       = var.tag_owner
    workload    = var.tag_workload

  }

}
