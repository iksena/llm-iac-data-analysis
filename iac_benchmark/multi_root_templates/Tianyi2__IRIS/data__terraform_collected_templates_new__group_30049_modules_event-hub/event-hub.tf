# Event Hub Namespace
resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  name                          = var.event_hub_namespace_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = "Standard"
  capacity                      = 2
  public_network_access_enabled = false
  network_rulesets = [{
    default_action                 = "Deny"
    trusted_service_access_enabled = true
    public_network_access_enabled  = false
    virtual_network_rule           = []
    ip_rule                        = []
  }]
}

# Event hub topic
resource "azurerm_eventhub" "eventhub" {
  name                = var.event_hub_name
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 7
}

# Create private dns zone for eventhub default dns zone
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_link" {
  name                  = format("dnslink-eh-001")
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Create private endpoint for Event Hub
resource "azurerm_private_endpoint" "pep-eventhub" {
  name                = format("pep-eh-001")
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = format("psc-pep-eh-001")
    private_connection_resource_id = azurerm_eventhub_namespace.eventhub-namespace.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }
  private_dns_zone_group {
    name                 = format("pdnszg-pep-eh-001")
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
  }
}
