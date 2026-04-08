output "out_eventbus_uri" {
  value     = "amqps://${azurerm_eventhub_namespace.eventbus_uri.name}.servicebus.windows.net"
  sensitive = true
}
