output "event_hub_namespace_id" {
  value = azurerm_eventhub_namespace.eventhub-namespace.id
}

output "event_hub_namespace_name" {
  value = azurerm_eventhub_namespace.eventhub-namespace.name  
}

output "event_hub_name" {
  value = azurerm_eventhub.eventhub.name  
}
