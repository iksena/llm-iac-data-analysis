
resource "azurerm_dns_zone" "example-public" {

/*
    references: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone     
*/

  resource_group_name = var.resource_group_name

  name                = var.dns_zone_name

    tags = {

        environment = var.tag_environment
        id          = var.tag_id
        owner       = var.tag_owner
        workload    = var.tag_workload

    }

}
