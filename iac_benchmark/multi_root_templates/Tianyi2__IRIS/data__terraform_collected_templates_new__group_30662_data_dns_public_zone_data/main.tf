
data "azurerm_dns_zone" "DNSZone" {

    /* 
      references
      - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone 
    */ 

    resource_group_name = var.resource_group_name

    name = var.dns_zone_name

}
