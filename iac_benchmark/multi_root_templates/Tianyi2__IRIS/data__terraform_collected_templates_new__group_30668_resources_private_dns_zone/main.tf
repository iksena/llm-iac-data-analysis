
resource "azurerm_private_dns_zone" "PrivateDNSZones" {

    /*
        references: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone 
    */ 
    
    resource_group_name = var.resource_group_name

    for_each = var.dns_zones
    name = each.value.dns_zone_name

    tags = {

        environment = var.tag_environment
        id          = var.tag_id
        owner       = var.tag_owner
        workload    = var.tag_workload

    }

}
